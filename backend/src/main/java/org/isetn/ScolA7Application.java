package org.isetn;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Arrays;
import org.springframework.stereotype.Component;

import org.isetn.entities.*;
import org.isetn.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;

@Component
@SpringBootApplication
public class ScolA7Application implements CommandLineRunner {
	@Autowired
	private FormationRepository formationRepository;

	@Autowired
	private ClasseRepository classeRepository;

	@Autowired
	private EtudiantRepository etudiantRepository;

	@Autowired
	private UserRepository userRepository;
	@Autowired
	private DepartementRepository depRepository;
	@Autowired
	private MatiereRepository matiereRepository;
	@Autowired
	private AbsenceRepository absenceRepository;
	@Autowired
	private NoteRepository noteRepository;
	@Autowired
	private RepositoryRestConfiguration repositoryRestConfiguration;

	public static void main(String[] args) {
		SpringApplication.run(ScolA7Application.class, args);
	}

	@Override
	public void run(String... args) throws Exception {

		Departement ti = depRepository.save(new Departement(null, "TI", null));
		Departement ge = depRepository.save(new Departement(null, "GE", null));
		Departement gc = depRepository.save(new Departement(null, "GC", null));
		Formation f1 = formationRepository.save(new Formation(null, "Oracle", 100, null));
		Formation f2 = formationRepository.save(new Formation(null, "J2EE", 10, null));
		Formation f3 = formationRepository.save(new Formation(null, "Angular", 120, null));
		Classe c1 = classeRepository.save(new Classe(null, "DSI31", 27, null, null, ti));
		Classe c2 = classeRepository.save(new Classe(null, "DSI32", 25, null, null, ti));
		Classe c3 = classeRepository.save(new Classe(null, "DSI33", 20, null, null, ti));
		Classe c4 = classeRepository.save(new Classe(null, "GC11", 20, null, null, gc));
		User u1 = userRepository.save(new User(null, "admin@gmail.com", "admin"));
		SimpleDateFormat fdate = new SimpleDateFormat("dd-MM-yyyy");

		etudiantRepository.save(new Etudiant(null, "Haithem", "Meddeb", fdate.parse("10-03-2021"), f1, c1));
		etudiantRepository.save(new Etudiant(null, "Mohamed", "Ben Mohamed", fdate.parse("1-04-2010"), f1, c1));
		etudiantRepository.save(new Etudiant(null, "Amin", "Ben Mahmoud", fdate.parse("19-07-2015"), f2, c1));
		etudiantRepository.save(new Etudiant(null, "Samia", "Ben Ahmed", fdate.parse("26-10-2014"), f3, c1));

		Etudiant e1 = etudiantRepository.save(new Etudiant(null, "Douaa", "Ben Charef", fdate.parse("11-02-2003"), f3, c3));
		Etudiant e2 = etudiantRepository.save(new Etudiant(null, "Mariem", "Younes", fdate.parse("05-06-2003"), f3, c3));
		Etudiant e3 = etudiantRepository.save(new Etudiant(null, "Ranim", "Ben Ali", fdate.parse("14-09-2002"), f1, c3));
		Etudiant e4 = etudiantRepository.save(new Etudiant(null, "Nour", "Hammami", fdate.parse("23-01-2003"), f2, c3));
		Etudiant e5 = etudiantRepository.save(new Etudiant(null, "Mehdi", "Bouazizi", fdate.parse("30-11-2002"), f3, c3));
		Etudiant e6 = etudiantRepository.save(new Etudiant(null, "Ines", "Chaabane", fdate.parse("17-04-2003"), f1, c3));


		matiereRepository.save(new Matiere(null, "Mathematics", 4, 30, c1));
		matiereRepository.save(new Matiere(null, "Physics", 3, 20, c1));
		matiereRepository.save(new Matiere(null, "Chemistry", 2, 15, c2));
		matiereRepository.save(new Matiere(null, "Biology", 3, 25, c2));


		Matiere afcp = matiereRepository.save(new Matiere(null, "AFCP", 2, 30, c3));       // TP
		Matiere soa = matiereRepository.save(new Matiere(null, "SOA", 3, 30, c3));         // cours
		Matiere flutter = matiereRepository.save(new Matiere(null, "Flutter", 2, 30, c3)); // TP
		Matiere plsql = matiereRepository.save(new Matiere(null, "PLSQL", 2, 30, c3));     // TP
		Matiere bi = matiereRepository.save(new Matiere(null, "BI", 3, 30, c3));           // cours
		Matiere archi = matiereRepository.save(new Matiere(null, "Archi", 2, 30, c3));     // cours


		abs(fdate, "11-11-2025", 1.5, e1, afcp);
		abs(fdate, "04-10-2025", 4.5, e1, afcp);
		abs(fdate, "20-10-2025", 1.5, e1, soa);
		abs(fdate, "23-10-2025", 3.0, e1, soa);
		abs(fdate, "16-10-2025", 3.0, e1, soa);

		abs(fdate, "12-11-2025", 3.0, e2, soa);
		abs(fdate, "14-11-2025", 4.5, e2, bi);
		abs(fdate, "18-11-2025", 1.5, e2, flutter);

		abs(fdate, "05-11-2025", 4.5, e3, soa);
		abs(fdate, "07-11-2025", 3.0, e3, bi);
		abs(fdate, "10-11-2025", 1.5, e3, afcp);

		abs(fdate, "03-11-2025", 6.0, e4, bi);
		abs(fdate, "19-11-2025", 1.5, e4, archi);

		abs(fdate, "06-11-2025", 1.5, e5, soa);
		abs(fdate, "13-11-2025", 3.0, e5, flutter);
		abs(fdate, "17-11-2025", 1.5, e5, plsql);

		abs(fdate, "09-11-2025", 3.0, e6, afcp);
		abs(fdate, "20-11-2025", 1.5, e6, bi);


		tp(e1, afcp, 14.0, 12.0);   cours(e1, soa, 11.0, 13.0);
		tp(e1, flutter, 15.0, 16.0); tp(e1, plsql, 13.0, 14.5);
		cours(e1, bi, 12.0, 10.5);  cours(e1, archi, 14.0, 15.0);

		tp(e2, afcp, 16.0, 15.0);   cours(e2, soa, 13.5, 14.0);
		tp(e2, flutter, 17.0, 18.0); tp(e2, plsql, 15.0, 16.0);
		cours(e2, bi, 14.0, 13.0);  cours(e2, archi, 16.0, 15.5);

		tp(e3, afcp, 10.0, 11.5);   cours(e3, soa, 9.0, 10.5);
		tp(e3, flutter, 12.0, 11.0); tp(e3, plsql, 13.0, 12.5);
		cours(e3, bi, 8.5, 11.0);   cours(e3, archi, 10.0, 9.5);

		tp(e4, afcp, 13.0, 14.0);   cours(e4, soa, 12.0, 12.5);
		tp(e4, flutter, 14.0, 15.0); tp(e4, plsql, 11.0, 12.0);
		cours(e4, bi, 9.0, 8.0);    cours(e4, archi, 13.0, 14.0);

		tp(e5, afcp, 8.0, 9.5);     cours(e5, soa, 10.0, 11.0);
		tp(e5, flutter, 10.5, 12.0); tp(e5, plsql, 9.0, 10.0);
		cours(e5, bi, 11.0, 12.5);  cours(e5, archi, 12.0, 11.5);

		tp(e6, afcp, 18.0, 17.0);   cours(e6, soa, 16.0, 17.5);
		tp(e6, flutter, 19.0, 18.5); tp(e6, plsql, 17.0, 16.0);
		cours(e6, bi, 15.5, 16.0);  cours(e6, archi, 17.0, 18.0);
	}

	private void abs(SimpleDateFormat f, String date, double h, Etudiant e, Matiere m) throws Exception {
		absenceRepository.save(new Absence(null, f.parse(date), h, e, m));
	}

	private void tp(Etudiant e, Matiere m, double tp1, double tp2) {
		noteRepository.save(new Note(null, tp1, tp2, null, null, e, m));
	}

	private void cours(Etudiant e, Matiere m, double ds, double examen) {
		noteRepository.save(new Note(null, null, null, ds, examen, e, m));
	}
}