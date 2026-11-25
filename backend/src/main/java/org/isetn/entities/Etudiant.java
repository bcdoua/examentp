package org.isetn.entities;

import java.util.Date;
import javax.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Etudiant {
	@Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String prenom;
	private String nom;
	@Temporal(TemporalType.DATE)
	private Date dateNais;

	@ManyToOne
	private Formation formation;

	@ManyToOne
	private Classe classe;
}
