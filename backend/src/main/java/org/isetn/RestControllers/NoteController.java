package org.isetn.RestControllers;

import java.util.List;
import org.isetn.entities.Note;
import org.isetn.repository.NoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("note")
public class NoteController {
	@Autowired
	private NoteRepository repo;

	@PostMapping("/add")
	public Note add(@RequestBody Note n) { return repo.save(n); }

	@PutMapping("/update")
	public Note update(@RequestBody Note n) { return repo.save(n); }

	@GetMapping("/all")
	public List<Note> getAll() { return repo.findAll(); }

	@GetMapping("/findByEtudiantId/{id}")
	public List<Note> getByEtudiant(@PathVariable Long id) { return repo.findByEtudiantId(id); }

	@DeleteMapping("/delete")
	public void delete(@RequestParam Long id) { repo.deleteById(id); }
}
