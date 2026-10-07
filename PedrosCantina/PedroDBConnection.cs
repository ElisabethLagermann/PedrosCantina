using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Cryptography.X509Certificates;
using System.Text;

namespace PedrosCantina
{
    public class PedroDBConnection
    {
        SqlConnection _connection;

        private string _connectionString;

      

        public PedroDBConnection()
        {

            //Setter up, at min connection string er secret

            var config = new ConfigurationBuilder()

                .AddUserSecrets(Assembly.GetExecutingAssembly(), optional: true)
                .Build();


             _connectionString = config["ElisabethsSecretString"];
        }

        public PedroDBConnection(string connectionString)
        {
            ConnectionString = connectionString;
        }


        public string ConnectionString
        {
            get { return _connectionString; }
            set { _connectionString = value; }
        }

        
        public SqlConnection Connection
        {
            get { return _connection; }
            set { _connection = value; }
        }


        //Metoder

        public void ConnectToDatabase()
        {

            _connection = new SqlConnection(_connectionString);

            _connection.Open();

        }

        public void DisconnectFromDatabase()
        {
            _connection.Close();
        }
  
    }
}
