using Microsoft.AspNet.Builder;
using Microsoft.AspNet.Hosting;
using Microsoft.AspNet.Http;

namespace AppOffline
{
    public class Startup
    {
        public void Configure(IApplicationBuilder app)
        {
            app.UseIISPlatformHandler();

            app.Run(async context =>
            {
                await context.Response.WriteAsync("Maintentance");
            });
        }

        public static void Main(string[] args)
        {
            var host = new WebHostBuilder()
                .UseDefaultConfiguration(args)
                .UseIISPlatformHandlerUrl()
                .UseServer("Microsoft.AspNet.Server.Kestrel")
                .UseStartup<Startup>()
                .Build();

            host.Run();
        }
    }
}
