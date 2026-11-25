package org.isetn.entities;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;

import javax.persistence.CascadeType;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Matiere {
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	private Long code;
	private String nom;
	private int coef;
	private int nbHeures;
	//@JsonIgnore
	@ManyToOne
    private Classe classe;
}