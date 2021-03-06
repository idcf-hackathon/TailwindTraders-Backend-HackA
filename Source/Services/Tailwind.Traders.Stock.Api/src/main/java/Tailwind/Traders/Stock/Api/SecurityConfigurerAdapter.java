package Tailwind.Traders.Stock.Api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class SecurityConfigurerAdapter extends  WebSecurityConfigurerAdapter {

	@Autowired
	private JwtConfig jwtConfig;
	
	@Override
	protected void configure(HttpSecurity http) throws Exception{
		http.csrf().disable().cors().and()
			.addFilter(new JWTAuthorizationFilter(authenticationManager(), jwtConfig))
			.authorizeRequests()
				.antMatchers("/v1/stock/*", "/", "/swagger-ui.html").permitAll()
				.antMatchers("/").permitAll()
				.antMatchers("/swagger-ui.html").permitAll()
				.anyRequest().authenticated();
	}
	
	@Bean
	public JwtConfig jwtConfig() {
        	return new JwtConfig();
	}
}
