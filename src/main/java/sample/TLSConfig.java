package sample;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.boot.autoconfigure.ldap.LdapProperties;
import org.springframework.boot.ssl.SslBundle;
import org.springframework.boot.ssl.SslBundles;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.ldap.core.support.DefaultTlsDirContextAuthenticationStrategy;
import org.springframework.ldap.core.support.LdapContextSource;

import javax.net.ssl.SSLContext;

@Configuration
@Profile({"tls", "mutualtls"})
public class TLSConfig {

	@Bean
	public LdapContextSource contextSource(SslBundles bundles, LdapProperties ldapProperties) throws JsonProcessingException {
        SslBundle bundle = bundles.getBundle("ldap");
        SSLContext sslContext = bundle.createSslContext();

        DefaultTlsDirContextAuthenticationStrategy strategy = new DefaultTlsDirContextAuthenticationStrategy();
        strategy.setHostnameVerifier((hostname, session) -> true);
        strategy.setShutdownTlsGracefully(true);
        strategy.setSslSocketFactory(sslContext.getSocketFactory());

        LdapContextSource contextSource = new LdapContextSource();
        contextSource.setBase(ldapProperties.getBase());
        contextSource.setUrl(ldapProperties.getUrls()[0]);
        contextSource.setUserDn(ldapProperties.getUsername());
        contextSource.setPassword(ldapProperties.getPassword());
        contextSource.setAuthenticationStrategy(strategy);

		return contextSource;
	}
}
