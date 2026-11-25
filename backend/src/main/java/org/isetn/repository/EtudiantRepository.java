package org.isetn.repository;

import java.util.List;
import org.isetn.entities.Etudiant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EtudiantRepository extends JpaRepository<Etudiant, Long> {
	List<Etudiant> findByClasseCodClass(Long id);
}
