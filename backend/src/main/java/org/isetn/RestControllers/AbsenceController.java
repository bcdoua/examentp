package org.isetn.RestControllers;

import java.util.List;
import org.isetn.entities.Absence;
import org.isetn.repository.AbsenceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("absence")
public class AbsenceController {
	@Autowired
	private AbsenceRepository repo;

	@PostMapping("/add")
	public Absence add(@RequestBody Absence a) { return repo.save(a); }

	@PutMapping("/update")
	public Absence update(@RequestBody Absence a) { return repo.save(a); }

	@GetMapping("/all")
	public List<Absence> getAll() { return repo.findAll(); }

	@GetMapping("/findByEtudiantId/{id}")
	public List<Absence> getByEtudiant(@PathVariable Long id) { return repo.findByEtudiantId(id); }

	@DeleteMapping("/delete")
	public void delete(@RequestParam Long id) { repo.deleteById(id); }
}
