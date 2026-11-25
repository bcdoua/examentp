package org.isetn;

import org.isetn.entities.*;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

@Configuration
public class GlobalRepositoryRestConfigurer implements RepositoryRestConfigurer {
	@Override
	public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config, CorsRegistry cors) {
		config.exposeIdsFor(Departement.class, Classe.class, Etudiant.class, Matiere.class,
				Formation.class, User.class, Absence.class, Note.class);
		cors.addMapping("/**").allowedOrigins("*").allowedMethods("*");
	}
}
