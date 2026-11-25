package org.isetn.entities;

import java.util.Date;
import javax.persistence.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Absence {
	@Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Temporal(TemporalType.DATE)
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Date dateA;

	/** Nombre d'heures d'absence */
	private double nha;

	@ManyToOne
	private Etudiant etudiant;

	@ManyToOne
	private Matiere matiere;
}
