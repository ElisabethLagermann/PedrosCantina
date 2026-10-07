using Microsoft.Data.SqlClient;
using PedrosCantina.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.Common;
using System.Text;

namespace PedrosCantina.Repo
{
    public class MedarbejderRepository
    {
        //Instansfelt

        private List<Medarbejder> _medarbejdere;

        private PedroDBConnection _dbConnection = new PedroDBConnection();
        
       
        //Konstruktører

        public MedarbejderRepository()
        {
            _medarbejdere = new List<Medarbejder>();
            _dbConnection = new PedroDBConnection();
        }

        public MedarbejderRepository(List<Medarbejder> medarbejdere, PedroDBConnection dbConnection)
        {
            Medarbejdere = medarbejdere;
            _dbConnection = dbConnection;
        }


        //Properties

        public List<Medarbejder> Medarbejdere
        {
            get {  return _medarbejdere; }
            set { _medarbejdere = value; }
        }

        public PedroDBConnection DbConnection
        {
            get { return _dbConnection; }
            set { _dbConnection = value; }
        }

        //Metoder

        //ToString-metode

        public override string ToString()
        {
            string resultat = "";

            foreach (Medarbejder m in _medarbejdere)
            {
                resultat = resultat + m + ", ";
            }

            return resultat;

        }


        //CRUD-metoder implementeret via SQL-scripts

        public Medarbejder Create(Medarbejder medarbejder)
        {
            _dbConnection.ConnectToDatabase();
            

            string sql = "INSERT INTO Medarbejder (Navn, Telefon, Email, Adresse, ErLeder)" +
                "VALUES (@Navn, @Telefon, @Email, @Adresse, @ErLeder)";

            SqlCommand command = new SqlCommand(sql, _dbConnection.Connection);


            command.Parameters.AddWithValue("@Navn", medarbejder.Navn);
            command.Parameters.AddWithValue("@Telefon", medarbejder.Telefon);
            command.Parameters.AddWithValue("@Email", medarbejder.Email);
            command.Parameters.AddWithValue("@Adresse", medarbejder.Adresse);
            command.Parameters.AddWithValue("@ErLeder", medarbejder.ErLeder);

            int rowsAffected = command.ExecuteNonQuery();

            _dbConnection.DisconnectFromDatabase();

            if (rowsAffected == 0)
            {
                throw new ArgumentException("Fejl. Ingen rækker påvirket, da der ikke er oprettet en ny medarbejder!");
            }

            return medarbejder;

        }


        public List<Medarbejder> ReadAll()
        {

            List<Medarbejder> alleMedarbejdere = new List<Medarbejder>();

            _dbConnection.ConnectToDatabase();


            string sql = "SELECT * FROM Medarbejder";

            SqlCommand command = new SqlCommand(sql, _dbConnection.Connection);

            SqlDataReader reader = command.ExecuteReader();

            while (reader.Read())
            {
                int id = (int)reader["MedarbejderId"];
                string navn = (string)reader["Navn"];
                string telefon = (string)reader["Telefon"];
                string email = (string)reader["Email"];
                string adresse = (string)reader["Adresse"];
                bool erLeder = (bool)reader["ErLeder"];

                alleMedarbejdere.Add(new Medarbejder(id, navn, telefon, email, adresse, erLeder));
            }

           
            _dbConnection.DisconnectFromDatabase();

            return alleMedarbejdere;

        }

        public Medarbejder GetById(int idPaaMedarbejder)
        {
            _dbConnection.ConnectToDatabase();

            string sql = "SELECT * FROM Medarbejder " +
                "WHERE MedarbejderId = @MedarbejderId";

            SqlCommand command = new SqlCommand(sql, _dbConnection.Connection);

            command.Parameters.AddWithValue("@MedarbejderId", idPaaMedarbejder);

            SqlDataReader reader = command.ExecuteReader();

            Medarbejder medarbejderFundet = null;

            if(reader.Read())
            {
                int id = (int)reader["MedarbejderId"];
                string navn = (string)reader["Navn"];
                string telefon = (string)reader["Telefon"];
                string email = (string)reader["Email"];
                string adresse = (string)reader["Adresse"];
                bool erLeder = (bool)reader["ErLeder"];


                medarbejderFundet = new Medarbejder(id, navn, telefon, email, adresse, erLeder);
            }

            else
            {
                
                _dbConnection.DisconnectFromDatabase();

                throw new KeyNotFoundException($"Fejl. Der eksisterer ingen medarbejder med id: {idPaaMedarbejder}!");
            }

            _dbConnection.DisconnectFromDatabase();

            return medarbejderFundet;

        }


        public Medarbejder Update(int idPaaMedarbejder, Medarbejder opdateretMedarbejder)
        {

            _dbConnection.ConnectToDatabase();

            string sql = "UPDATE Medarbejder " +
                "SET Navn = @Navn, Telefon = @Telefon, Email = @Email, Adresse = @Adresse, ErLeder = @ErLeder " +
                "WHERE MedarbejderId = @MedarbejderId ";

            SqlCommand command = new SqlCommand(sql, _dbConnection.Connection);

            command.Parameters.AddWithValue("@MedarbejderId", idPaaMedarbejder);
            command.Parameters.AddWithValue("@Navn", opdateretMedarbejder.Navn);
            command.Parameters.AddWithValue("@Telefon", opdateretMedarbejder.Telefon);
            command.Parameters.AddWithValue("@Email", opdateretMedarbejder.Email);
            command.Parameters.AddWithValue("@Adresse", opdateretMedarbejder.Adresse);
            command.Parameters.AddWithValue("@ErLeder", opdateretMedarbejder.ErLeder);


            int rowsAffected = command.ExecuteNonQuery();

            _dbConnection.DisconnectFromDatabase();

            if(rowsAffected == 1)
            {
                return GetById(idPaaMedarbejder);
            }

            throw new KeyNotFoundException($"Fejl. Ingen rækker blev ændret, da der ikke eksisterer en medarbejder med id: {idPaaMedarbejder}");

        }

        public Medarbejder Delete(int idPaaMedarbejder)
        {

            Medarbejder medarbejderTilSletning = GetById(idPaaMedarbejder);

            _dbConnection.ConnectToDatabase();

            string sql = "DELETE FROM Medarbejder " +
                "WHERE MedarbejderId = @MedarbejderId ";

            SqlCommand command = new SqlCommand(sql, _dbConnection.Connection);

            command.Parameters.AddWithValue("@MedarbejderId", idPaaMedarbejder);

            int rowsAffected = command.ExecuteNonQuery();

            _dbConnection.DisconnectFromDatabase();


            if (rowsAffected != 1)
            {
                throw new ArgumentException($"Fejl. Ingen medarbejder med ID: {idPaaMedarbejder} eksisterer, og medarbejderen kan derfor ikke slettes fra databasen");
            }

           
                return medarbejderTilSletning;
           
        }





    }
}
