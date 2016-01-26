using System;
using System.IO;

namespace IISDeploy
{
    public static class Program
    {
        public static void Main(string[] args)
        {
            if (args.Length != 3)
            {
                PrintUsage();
                return;
            }

            if (Directory.Exists(args[0]))
            {
                Console.WriteLine($"Invalid source folder {args[0]}\n");
                PrintUsage();
                return;
            }

            if (Directory.Exists(args[1]))
            {
                Console.WriteLine($"Invalid destination folder {args[1]}\n");
                PrintUsage();
                return;
            }

            try
            {
                new IISDeployCommand(args[0], args[1]).Run();
            }
            catch(Exception e)
            {
                Console.WriteLine(e);
            }
        }

        private static void PrintUsage()
        {
            Console.WriteLine("IISDeploy - deploys a web application to IIS.");
            Console.WriteLine("IISDeploy <source folder> <destination folder> <app_offline html>");
        }
    }
}
