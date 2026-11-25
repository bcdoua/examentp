package org.isetn.entities;

import javax.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Note {
	@Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	// TP1/TP2 remplis => module TP ; DS/Examen remplis => module de cours
	private Double tp1;
	private Double tp2;
	private Double ds;
	private Double examen;

	@ManyToOne
	private Etudiant etudiant;

	@ManyToOne
	private Matiere matiere;
}
