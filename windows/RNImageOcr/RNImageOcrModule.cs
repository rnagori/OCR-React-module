using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Image.Ocr.RNImageOcr
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNImageOcrModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNImageOcrModule"/>.
        /// </summary>
        internal RNImageOcrModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNImageOcr";
            }
        }
    }
}
