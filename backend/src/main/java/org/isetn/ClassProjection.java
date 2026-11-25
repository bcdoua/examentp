package org.isetn;

import org.isetn.entities.Classe;
import org.springframework.data.rest.core.config.Projection;

@Projection(name = "p1", types = { Classe.class })
public interface ClassProjection {
	public String getNomClass();
	public int getNbreEtud();
}
