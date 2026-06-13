package com.ngonzano.springcloud.msmc.products.services;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.ngonzano.libs.msvc.commons.entities.Product;

@Service
public interface ProductService {
    public List<Product> findAll();

    public Optional<Product> findById(Long id);

    public Product save(Product product);

    public void deleteById(Long id);

    public Product update(Long id, Product product);

}
