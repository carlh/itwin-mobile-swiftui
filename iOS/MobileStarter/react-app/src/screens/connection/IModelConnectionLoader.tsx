import { IModel, LocalBriefcaseProps, SyncMode } from '@bentley/imodeljs-common';
import { BriefcaseConnection, IModelConnection, NativeApp } from '@bentley/imodeljs-frontend';
import { ProgressInfo } from '@bentley/itwin-client';
import { Messenger } from '@itwin/mobile-sdk-core';
import React, { useCallback, useEffect, useState } from 'react';
import { Screen } from '../../Screen';
import { ModelScreen } from '../model/ModelScreen';

import './iModelConnectionLoader.scss';

interface iModelData {
  iModelId: string;
  contextId: string;
}

const IModelConnectionLoader = () => {
  const [iModelData, setIModelData] = useState<iModelData | undefined>(undefined);
  const [progress, setProgress] = useState<ProgressInfo | number>(0);
  const [currentIModelConnection, setCurrentIModelConnection] = useState<IModelConnection | undefined>(undefined);
  const [iModelFilename, setIModelFilename] = useState<string | undefined>(undefined);

  useEffect(() => {
    const getInfo = async () => {
      let selectedIModelId = await Messenger.query('selectedIModel');
      let iModelData: iModelData = JSON.parse(atob(selectedIModelId));

      console.log(iModelData);
      setIModelData(iModelData);
    };

    getInfo();
    // setTimeout(() => {
    //   debugger;

    // }, 20000);
  }, []);

  const openDownloadedIModel = useCallback(async (data: iModelData): Promise<boolean> => {
    const localBriefcases = await NativeApp.getCachedBriefcases(data.iModelId);
    if (localBriefcases.length === 0) {
      return false;
    }

    let briefcase = localBriefcases[0];
    openIModel(briefcase);
    return true;
  }, []);

  const downloadIModel = useCallback(async () => {
    if (!iModelData) {
      // We must have valid context and iModel IDs
      return;
    }

    if (await openDownloadedIModel(iModelData)) {
      // If the briefcase is already downloaded, we can just open it.
      // This won't work if there are updates though, might need to look into that.
      return;
    }

    const downloader = await NativeApp.requestDownloadBriefcase(
      iModelData.contextId,
      iModelData.iModelId,
      {
        syncMode: SyncMode.PullOnly,
      },
      undefined,
      (progress: ProgressInfo) => {
        setProgress(progress);
      },
    );

    await downloader.downloadPromise;

    const localBriefcases = await NativeApp.getCachedBriefcases(iModelData.iModelId);

    openIModel(localBriefcases[0]);
  }, [iModelData, openDownloadedIModel]);

  const openIModel = async (briefcase: LocalBriefcaseProps) => {
    let connection = await BriefcaseConnection.openFile(briefcase);
    setCurrentIModelConnection(connection);
    setIModelFilename(briefcase.fileName);
  };

  useEffect(() => {
    if (iModelData) {
      downloadIModel();
    }
  }, [iModelData, downloadIModel]);

  return !currentIModelConnection ? (
    <Screen>
      <div className="imc_container">
        {!iModelData && <h1>Connecting to the sample iModel....</h1>}
        {iModelData && (
          <>
            <h1>Downloading iModel</h1>
            <p>{progress}% complete</p>
          </>
        )}
      </div>
    </Screen>
  ) : (
    <ModelScreen filename={iModelFilename!} iModel={currentIModelConnection!} onBack={() => {}} />
  );
};

export default IModelConnectionLoader;
