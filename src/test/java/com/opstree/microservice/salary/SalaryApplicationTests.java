package com.opstree.microservice.salary;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@Disabled("Skipping context load because Cassandra DB is not available in CI")
@Tag("integration")
@SpringBootTest
class SalaryApplicationTests {

    @Test
    void contextLoads() {
    }

}
