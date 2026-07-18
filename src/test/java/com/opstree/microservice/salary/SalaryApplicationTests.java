package com.opstree.microservice.salary;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.cassandra.core.CassandraTemplate;

@Tag("integration")
@SpringBootTest
class SalaryApplicationTests {

    // This tricks Spring Boot into thinking it has a database connection
    @MockBean
    private CassandraTemplate cassandraTemplate;

    @Test
    void contextLoads() {
        // Now this will PASS successfully without a real DB!
    }
}
