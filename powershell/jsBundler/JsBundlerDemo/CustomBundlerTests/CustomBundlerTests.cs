using System;
using System.IO;
using CustomBundler;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CustomBundlerTests
{
    [TestClass]
    public class CustomBundlerTests
    {
        [TestMethod]
        public void TestCreateBundler()
        {
            Bundler bun = new Bundler();
        }

        [TestMethod]
        public void TestMinimiseJavaScriptFile()
        {
            Bundler bun = new Bundler();

            string jsPath = GetPathToTestData(@"js\SampleJavaScript1.js");

            //cleanup after a previous run:
            string outPath = bun.GetPathForMinimised(jsPath);
            if (File.Exists(outPath))
            {
                File.Delete(outPath);
            }

            bun.MinimiseFileToFile(jsPath, out outPath);

            CheckThatFileExists(outPath);

            Assert.AreEqual(Path.GetExtension(jsPath), Path.GetExtension(outPath));
        }

        private void CheckThatFileExists(string outPath)
        {
            Assert.IsTrue(File.Exists(outPath));
            FileInfo info = new FileInfo(outPath);
            Assert.IsTrue(info.Length > 0);
        }

        [TestMethod]
        public void TestBundleJavaScriptFiles()
        {
            CheckBundleSomeFiles(@"js\bundled\JsBundleNotMinimise.js.custombundle", false, ".js");
        }

        private void CheckBundleSomeFiles(string pathToBundle, bool isMinimising, string expectedExtension)
        {
            Bundler bun = new Bundler();

            string bunPath = GetPathToTestData(pathToBundle);

            //no need to cleanup - since robocopy will do this in build event.

            string outPath;
            bun.ProcessBundle(GetPathToTestDataDir(), bunPath, out outPath);

            CheckThatFileExists(outPath);

            expectedExtension = Path.GetExtension(expectedExtension);
            Assert.AreEqual(expectedExtension, Path.GetExtension(outPath));

            //check there is/is not minimised file:
            string minimisedPath = outPath.ToLower().Replace(expectedExtension, ".min" + expectedExtension);
            Assert.AreEqual(isMinimising, File.Exists(minimisedPath));
        }

        [TestMethod]
        public void TestBundleAndMinimiseJavaScriptFiles()
        {
            CheckBundleSomeFiles(@"js\bundled\JsBundleAndMinimise.js.custombundle", true, ".js");
        }

        [TestMethod]
        public void TestMinimiseCssFile()
        {
            Bundler bun = new Bundler();

            string path = GetPathToTestData(@"css\SampleStyleSheet1.css");

            //cleanup after a previous run:
            string outPath = bun.GetPathForMinimised(path);
            if (File.Exists(outPath))
            {
                File.Delete(outPath);
            }

            bun.MinimiseFileToFile(path, out outPath);

            Assert.IsTrue(File.Exists(outPath));
            FileInfo info = new FileInfo(outPath);
            Assert.IsTrue(info.Length > 0);

            Assert.AreEqual(Path.GetExtension(path), Path.GetExtension(outPath));
        }

        [TestMethod]
        public void TestBundleCssFiles()
        {
            CheckBundleSomeFiles(@"css\bundled\CssBundleNotMinimise.css.custombundle", false, ".css");
        }

        [TestMethod]
        public void TestBundleAndMinimiseCssFiles()
        {
            CheckBundleSomeFiles(@"css\bundled\CssBundleAndMinimise.css.custombundle", true, ".css");
        }

        private string GetPathToTestDataDir()
        {
            string testDataDir = Path.Combine(Path.GetTempPath(), "CustomBundlerTestData"); //copied in pre build event
            return testDataDir;
        }

        private string GetPathToTestData(string path)
        {
            string testDataDir = GetPathToTestDataDir();

            path = Path.Combine(testDataDir, path);

            return path;
        }
    }
}
