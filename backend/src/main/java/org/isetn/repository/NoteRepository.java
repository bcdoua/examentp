package org.isetn.repository;

import java.util.List;
import org.isetn.entities.Note;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NoteRepository extends JpaRepository<Note, Long> {
	List<Note> findByEtudiantId(Long id);
}
