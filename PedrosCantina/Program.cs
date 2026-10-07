using PedrosCantina.Model;
using PedrosCantina.Repo;

MedarbejderRepository medarbejderRepo = new MedarbejderRepository();

Medarbejder m1 = new Medarbejder(1, "Lars Larsen", "12312332", "testmail@gmail.com", "testadresse", false);

medarbejderRepo.Create(m1);


