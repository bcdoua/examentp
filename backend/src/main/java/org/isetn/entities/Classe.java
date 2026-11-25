package org.isetn.entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.Collection;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Classe {
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	private Long codClass;
	private String nomClass;
	private int nbreEtud;

	@JsonIgnore
	@OneToMany(mappedBy="classe" , cascade = CascadeType.ALL)
	private List<Etudiant> etudiants; 
	
	@JsonIgnore
	@OneToMany(mappedBy="classe" , cascade = CascadeType.ALL)
	private List<Matiere> matieres; 
	
	@ManyToOne
    private Departement departement;
	
	/*
	 * L'annotation @JsonIgnore est utilisée pour exclure une propriété 
	 * de la sérialisation et de la désérialisation JSON. Dans votre cas, 
	 * vous l'avez utilisée sur la propriété etudiants de la classe "Classe". 
	 * Cela signifie que lorsqu'un objet "Classe" est sérialisé en JSON, 
	 * la propriété etudiants ne sera pas incluse dans la représentation JSON. 
	 * Cela peut être utile pour éviter les boucles infinies lors de la sérialisation 
	 * d'objets imbriqués.
	 * */
	
	
}
