/*---------------------------------------------------------------------------------------------
* Copyright (c) Bentley Systems, Incorporated. All rights reserved.
* See LICENSE.md in the project root for license terms and full copyright notice.
*--------------------------------------------------------------------------------------------*/
import { Config } from "@bentley/bentleyjs-core";

/**
 * Setup configuration for the application
 */
export default function setupEnv() {
  Config.App.merge({
    // NOTE: This code expects an environment variable called BUDDI_REGION_CODE
    // is set by the native code that setups up the backend.
    imjs_buddi_resolve_url_using_region: process.env.BUDDI_REGION_CODE,
  });
}
