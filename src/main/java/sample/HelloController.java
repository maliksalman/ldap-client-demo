/*
 * Copyright 2005-2023 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package sample;

import org.springframework.ldap.core.AttributesMapper;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class HelloController {

	private final LdapTemplate ldap;

    public HelloController(LdapTemplate ldap) {
        this.ldap = ldap;
    }

	@GetMapping("/cn/{name}")
	public List<User> cn(@PathVariable("name") String name) {

		AttributesMapper<User> mapper = attrs -> new User(name,
				attrs.get("cn").get().toString(),
				attrs.get("userPassword").get().toString());

		return this.ldap.search("ou=people", "uid=" + name, mapper);
	}

	record User(
			String uid,
			String name,
			String password
	) {	}
}
