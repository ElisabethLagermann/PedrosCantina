using PedrosCantina.Model;
using PedrosCantina.Repo;

//Til egne tests af CRUD-metoderne


MedarbejderRepository medarbejderRepo = new MedarbejderRepository();

Medarbejder m1 = new Medarbejder(1, "Lars Larsen", "12312332", "testmail@gmail.com", "testadresse", false);

//Tester Create-metoden:

medarbejderRepo.Create(m1);

Console.WriteLine("Tjekker min liste over medarbejdere efter create-metoden via ReadAll-metoden");

foreach (Medarbejder m in medarbejderRepo.ReadAll())
{
    Console.WriteLine(m);
}

//Tester GetById-metoden

Console.WriteLine(medarbejderRepo.GetById(2));

//Tester update-metoden

Medarbejder m2 = new Medarbejder(13, "Sine Knudsen", "12344321", "SineK@gmail.com", "Amagerlandevej 1, 2300 Kbh S", false);

medarbejderRepo.Update(13, m2);

Console.WriteLine(medarbejderRepo.GetById(13));

//Tester Delete-metoden og holder den op med den nu forhåbentligt opdaterede medarbejderliste via ReadAll-metoden:

medarbejderRepo.Delete(13);

Console.WriteLine("Tjekker min liste over medarbejdere efter sletning af id = 13");

foreach (Medarbejder m in medarbejderRepo.ReadAll())
{
    Console.WriteLine(m);
}

