import React, { useCallback, useEffect, useState } from 'react';
import { LocalBriefcaseProps, SyncMode } from '@bentley/imodeljs-common';
import { BriefcaseConnection, IModelConnection, NativeApp } from '@bentley/imodeljs-frontend';
import { ProgressInfo } from '@bentley/itwin-client';
import { Messenger } from '@itwin/mobile-sdk-core';
import { Screen, ModelScreen } from '../../Exports';

import './iModelConnectionLoader.scss';

interface iModelData {
  iModelId: string;
  contextId: string;
}

const IModelConnectionLoader = () => {
  const [iModelData, setIModelData] = useState<iModelData | undefined>(undefined);
  const [progress, setProgress] = useState<ProgressInfo>({ loaded: 0, percent: 0 });
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
    /**
     * IMPORTANT!  Uncomment this block and comment out the `getInfo` call above if
     * you need time to attach the Safari Web inspector to the process to catch it before
     * any of the important model loading JS starts executing.
     */
    // setTimeout(() => {
    //   debugger;
    //   getInfo();
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
        let percent = progress.percent;
        if (!percent && progress.total && progress.total > 0) {
          percent = (progress.loaded / progress.total) * 100;
        }
        progress.percent = percent;
        setProgress(progress);
      },
    );

    await downloader.downloadPromise;

    await openDownloadedIModel(iModelData);
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
            <p>{progress.percent?.toPrecision(3) ?? 0}% complete</p>
          </>
        )}
      </div>
    </Screen>
  ) : (
    <ModelScreen filename={iModelFilename!} iModel={currentIModelConnection!} onBack={() => {}} />
  );
};

export { IModelConnectionLoader };
