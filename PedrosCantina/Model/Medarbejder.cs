using System;
using System.Collections.Generic;
using System.Text;

namespace PedrosCantina.Model
{
    public class Medarbejder
    {

        //Instansfelter

        private int _medarbejderId;
        private string _navn;
        private string _telefon;
        private string _email;
        private string _adresse;
        private bool _erLeder;


        //Konstruktører

        public Medarbejder()
        {
            _medarbejderId = 0;
            _navn = "";
            _telefon = "";
            _email = "";
            _adresse = "";
            _erLeder = false;
        }

        public Medarbejder(int medarbejderId, string navn, string telefon, string email, string adresse, bool erLeder)
        {
            MedarbejderId = medarbejderId;
            Navn = navn;
            Telefon = telefon;
            Email = email;
            Adresse = adresse;
            ErLeder = erLeder;
        }

        //Properties

        public int MedarbejderId
        {
            get { return _medarbejderId; }
            set { _medarbejderId = value; }
        }

        public string Navn
        {
            get { return _navn; }
            set { _navn = value; }
        }

        public string Telefon
        {
            get { return _telefon; }
            set { _telefon = value; }
        }

        public string Email
        {
            get { return _email; }
            set { _email = value; }
        }

        public string Adresse
        {
            get { return _adresse; }
            set { _adresse = value; }
        }

        public bool ErLeder
        {
            get { return _erLeder; }
            set { _erLeder = value; }
        }


        //ToString-metode

        public override string ToString()
        {
            return $"Medarbejderens ID: {MedarbejderId} \n" +
                $"Fulde navn: {Navn} \n" +
                $"Telefonnummer: {Telefon} \n" +
                $"Email: {Email} \n" +
                $"Er medarbejderen leder? (true/false): {ErLeder}";
        }

    }
}
