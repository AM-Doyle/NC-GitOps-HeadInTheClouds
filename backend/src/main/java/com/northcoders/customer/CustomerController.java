package com.northcoders.customer;

import com.northcoders.jwt.JWTUtil;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;

@RestController
@RequestMapping("api/v1/customers")
public class CustomerController {

    private final CustomerService customerService;
    private final JWTUtil jwtUtil;
    private Counter counter;

    public CustomerController(CustomerService customerService,
                              JWTUtil jwtUtil, MeterRegistry registry) {
        this.customerService = customerService;
        this.jwtUtil = jwtUtil;

        this.counter = Counter.builder("user_registered").
                tag("version", "v1").
                description("New user registered").
                register(registry);
    }

    

    

    @GetMapping
    public List<CustomerDTO> getCustomers() {
        return customerService.getAllCustomers();
    }

    @GetMapping("{customerId}")
    public CustomerDTO getCustomer(
            @PathVariable("customerId") Integer customerId) {
        return customerService.getCustomer(customerId);
    }

    @PostMapping
    public ResponseEntity<?> registerCustomer(
            @RequestBody CustomerRegistrationRequest request) {
        counter.increment();
        customerService.addCustomer(request);
        String jwtToken = jwtUtil.issueToken(request.email(), "ROLE_USER");
        return ResponseEntity.ok()
                .header(HttpHeaders.AUTHORIZATION, jwtToken)
                .build();
    }

    @DeleteMapping("{customerId}")
    public void deleteCustomer(
            @PathVariable("customerId") Integer customerId) {
        customerService.deleteCustomerById(customerId);
    }

    @PutMapping("{customerId}")
    public void updateCustomer(
            @PathVariable("customerId") Integer customerId,
            @RequestBody CustomerUpdateRequest updateRequest) {
        customerService.updateCustomer(customerId, updateRequest);
    }

}
