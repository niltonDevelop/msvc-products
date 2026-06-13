package com.ngonzano.springcloud.msmc.products.repositories;

import org.springframework.data.repository.CrudRepository;

import com.ngonzano.libs.msvc.commons.entities.Product;

public interface ProductRepository extends CrudRepository<Product, Long> {

}
