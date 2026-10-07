using PedrosCantina.Model;
using PedrosCantina.Repo;

/* 
 * Til delopgave 6 skal jeg afprøve mine CRUD-metoder fra medarbejderrepo'et i Program.cs
 * Det gør jeg ved at oprette et (default) objekt af mit medarbejderRepo.
 * Herved kan jeg connecte til databasen og kalde (afprøve) mine CRUD-metoder.
 */

MedarbejderRepository medarbejderRepo = new MedarbejderRepository();

bool setOp = true;

while(setOp)
{
    Console.WriteLine();
    Console.WriteLine("VELKOMMEN TIL PEDRO CANTINAS VAGTPLANSSYSTEM");
    Console.WriteLine();
    Console.WriteLine();
    Console.WriteLine("Valgmuligheder: ");
    Console.WriteLine();

    Console.WriteLine("Tast '1' for at få en liste over alle medarbejdere i Pedros Cantinas database");
    Console.WriteLine("Tast '2' for at søge efter en bestemt medarbejders kontaktinfo ud fra vedkommendes MedarbejderId");
    Console.WriteLine("Tast '3' for at oprette en ny medarbejder og tilføje vedkommende til databasen");
    Console.WriteLine("Tast '4' for at opdatere en medarbejders info i databasen");
    Console.WriteLine("Tast '5' for at slette en medarbejder fra databasen");
    Console.WriteLine("Tast '0' for at lukke programmet. ");
    Console.WriteLine();
    Console.WriteLine();

    string brugerValg = Console.ReadLine();


    if(brugerValg == "1")
    {
        Console.WriteLine("Her er en samlet liste over alle medarbejdere og deres kontaktinfo i databasen: ");

        foreach (Medarbejder m in medarbejderRepo.ReadAll())
        {
            Console.WriteLine(m + "\n ");
        }

    }

    if(brugerValg == "2")
    {
        Console.WriteLine("Indtast medarbejder-ID på den medarbejder, du gerne vil søge frem fra databasen: ");

        string input = Console.ReadLine();

        int talInput = int.Parse(input);

        Medarbejder medarbejderFundet = medarbejderRepo.GetById(talInput);

        if (medarbejderFundet != null)
        {
            Console.WriteLine($"Her er info om medarbejderen med ID = {talInput}:" +
                $"{medarbejderFundet}");
            Console.WriteLine();
        }

        else 
        { 
            Console.WriteLine("En bruger med dette ID eksisterer ikke i databasen");
            Console.WriteLine();
        }
    }

    if(brugerValg == "3")
    {
        Medarbejder nyMedarbejder = new Medarbejder();

        Console.WriteLine("Indtast info på den medarbejder, du gerne vil tilføje til databasen");
        Console.WriteLine();

        Console.Write("Navn: ");
        string medarbejderNavn = Console.ReadLine();
        Console.Write("Telefonnummer: ");
        string medarbejderTelefon = Console.ReadLine();
        Console.Write("Email: ");
        string medarbejderMail = Console.ReadLine();
        Console.Write("Adresse: ");
        string medarbejderAdresse = Console.ReadLine();
        Console.WriteLine("Er medarbejderen leder? Ja/Nej.");
        string medarbejderLeder = Console.ReadLine();

        
        //sætter det nye objekts parametre til de brugerindtastede info:
        nyMedarbejder.Navn = medarbejderNavn;
        nyMedarbejder.Telefon = medarbejderTelefon;
        nyMedarbejder.Email = medarbejderMail;
        nyMedarbejder.Adresse = medarbejderAdresse;
        if (string.Equals(medarbejderLeder?.Trim(), "Ja", StringComparison.OrdinalIgnoreCase))
        {
            nyMedarbejder.ErLeder = true;
        }
        if (string.Equals(medarbejderLeder?.Trim(), "Nej", StringComparison.OrdinalIgnoreCase))
        {
            nyMedarbejder.ErLeder = false;
        }

        Console.WriteLine($"Her er info på din nye medarbejder: {nyMedarbejder}.");
        Console.WriteLine();
        Console.WriteLine($"Tilføj {nyMedarbejder.Navn} til medarbejderdatabasen? Ja/Nej?");

        string bekraeft = Console.ReadLine();

        if (string.Equals(bekraeft?.Trim(), "Ja", StringComparison.OrdinalIgnoreCase))
        {
            medarbejderRepo.Create(nyMedarbejder);

            Console.WriteLine($"{nyMedarbejder.Navn} er nu tilføjet til medarbejderdatabasen.");
            Console.WriteLine();
        }
        else
        {
            Console.WriteLine($"{nyMedarbejder.Navn} blev ikke tilføjet til databasen.");
            Console.WriteLine();
        }

    }

    if(brugerValg == "4")
    {
        Console.WriteLine("Indtast medarbejder-ID på den medarbejder, du gerne vil opdatere");
        Console.WriteLine();

        string input = Console.ReadLine();

        int talInput = int.Parse(input);

        Medarbejder medarbejderAtOpdatere = medarbejderRepo.GetById(talInput);

        if (medarbejderAtOpdatere != null)
        {

            Console.WriteLine($"Her er info om medarbejderen med ID = {talInput}:" +
                $"{medarbejderAtOpdatere}");
            Console.WriteLine();

            Medarbejder opdateretMedarbejder = new Medarbejder();

            Console.WriteLine("Indtast info på den medarbejder, du gerne vil opdatere med");
            Console.WriteLine();

            Console.Write("Navn: ");
            string medarbejderNavn = Console.ReadLine();
            Console.Write("Telefonnummer: ");
            string medarbejderTelefon = Console.ReadLine();
            Console.Write("Email: ");
            string medarbejderMail = Console.ReadLine();
            Console.Write("Adresse: ");
            string medarbejderAdresse = Console.ReadLine();
            Console.WriteLine("Er medarbejderen leder? Ja/Nej.");
            string medarbejderLeder = Console.ReadLine();


            //sætter det nye objekts parametre til de brugerindtastede info:
            opdateretMedarbejder.Navn = medarbejderNavn;
            opdateretMedarbejder.Telefon = medarbejderTelefon;
            opdateretMedarbejder.Email = medarbejderMail;
            opdateretMedarbejder.Adresse = medarbejderAdresse;
            if(string.Equals(medarbejderLeder?.Trim(), "Ja", StringComparison.OrdinalIgnoreCase))
            {
                opdateretMedarbejder.ErLeder = true;
            }
            if (string.Equals(medarbejderLeder?.Trim(), "Nej", StringComparison.OrdinalIgnoreCase))
            {
                opdateretMedarbejder.ErLeder = false;
            }

            Console.WriteLine($"Nuværende oplysninger: {medarbejderAtOpdatere}");
            Console.WriteLine($"Nye oplysninger: {opdateretMedarbejder}");
            Console.WriteLine();
            Console.WriteLine("Bekræft ændringen med Ja/Nej");
            Console.WriteLine();

            string bekraeft = Console.ReadLine();

            if (string.Equals(bekraeft?.Trim(), "Ja",StringComparison.OrdinalIgnoreCase))
            {
                medarbejderRepo.Update(talInput, opdateretMedarbejder);

                Console.WriteLine("Databasen er nu opdateret");
                Console.WriteLine();
            }

            else
            {
                Console.WriteLine("Opdatering ej gennemført.");
                Console.WriteLine();
            }

        }

        else
        {
            Console.WriteLine("En bruger med dette ID eksisterer ikke i databasen");
        }
    }


    if(brugerValg == "5")
    {

        Console.WriteLine("Indtast medarbejder-ID på den medarbejder, du gerne vil slette fra databasen.");
        Console.WriteLine();

        string input = Console.ReadLine();

        int talInput = int.Parse(input);

        Medarbejder medarbejderFundet = medarbejderRepo.GetById(talInput);

        if (medarbejderFundet != null)
        {

            Console.WriteLine($"Ønsker du at slette {medarbejderFundet} med ID = {talInput}? ");
            Console.WriteLine();
            Console.WriteLine("Tast Ja/Nej");
            Console.WriteLine();

            string bekraeft = Console.ReadLine();

            if (string.Equals(bekraeft?.Trim(), "Ja",StringComparison.OrdinalIgnoreCase))
            {

                //Kunne have en try-catch her for at teste metoden for exceptions og fejl. 
                //Undladt det for nu.

                medarbejderRepo.Delete(talInput);

                Console.WriteLine("Medarbejderen er nu slettet fra databasen");
                Console.WriteLine();
            }
            else
            {
                Console.WriteLine("Sletning af medarbejderen er annuleret");
                Console.WriteLine();
            }
        }

        else
        {
            Console.WriteLine("En bruger med dette ID eksisterer ikke i databasen");
            Console.WriteLine();
        }
    }

    else if (brugerValg == "0")
    { setOp = false; }
}
