using Amazon;
using Amazon.Runtime;
using Amazon.SQS;
using Amazon.SQS.Model;
using Microsoft.AspNetCore.Mvc;

namespace quick_api.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    private readonly ILogger<WeatherForecastController> _logger;

    public WeatherForecastController(ILogger<WeatherForecastController> logger)
    {
        _logger = logger;
    }

    [HttpGet(Name = "GetWeatherForecast")]
    public IEnumerable<WeatherForecast> Get()
    {
        return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            })
            .ToArray();
    }

    [HttpPost]
    public async Task<IActionResult> PostMessageAsync([FromBody] string messageContent)
    {
        try
        {
            // Set up the Amazon SQS client
            var sqsConfig = new AmazonSQSConfig
            {
                ServiceURL = "http://localhost:4566", // Replace with your localstack endpoint
            };
            using var sqsClient = new AmazonSQSClient(new BasicAWSCredentials("ignore", "ignore"), sqsConfig);
            // Define the message attributes
            var messageRequest = new SendMessageRequest
            {
                QueueUrl = "http://localhost:4566/000000000000/my-quick-queue",
                MessageBody = messageContent
            };
            // Send the message to the SQS queue asynchronously
            var sendMessageResponse = await sqsClient.SendMessageAsync(messageRequest);
            Console.WriteLine($"Message sent with message ID: {sendMessageResponse.MessageId}");
            return Ok("Message sent successfully.");
        }
        catch (Exception ex)
        {
            // Handle exceptions, log errors, and return an appropriate response
            Console.Error.WriteLine($"Error sending message: {ex.Message}");
            return StatusCode(500, "Error sending the message to SQS.");
        }
    }
}