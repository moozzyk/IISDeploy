using System.IO;

namespace IISDeploy
{
    public class IISDeployCommand
    {
        private readonly string _sourceFolder;
        private readonly string _targetFolder;

        public IISDeployCommand(string sourceFolder, string targetFolder)
        {
            _sourceFolder = sourceFolder;
            _targetFolder = targetFolder;
        }

        public void Run()
        {

        }
    }
}