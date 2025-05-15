package com.beauty.service;

import com.beauty.model.Service;
import com.beauty.repository.ServiceRepository;

import java.util.ArrayList;
import java.util.List;

/**
 * Service class for managing beauty services
 */
public class ServiceService {
    private ServiceRepository serviceRepository;
    
    public ServiceService() {
        serviceRepository = new ServiceRepository();
    }
    
    /**
     * Get all services
     * @return List of all services
     */
    public List<Service> getAllServices() {
        return serviceRepository.getAllServices();
    }
    
    /**
     * Get a service by ID
     * @param id Service ID
     * @return Service if found, null otherwise
     */
    public Service getServiceById(String id) {
        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        
        return serviceRepository.getServiceById(id);
    }
    
    /**
     * Add a new service
     * @param service Service to add
     * @return true if successful, false otherwise
     */
    public boolean addService(Service service) {
        if (service == null || service.getName() == null || service.getName().trim().isEmpty()) {
            return false;
        }
        
        return serviceRepository.addService(service);
    }
    
    /**
     * Update an existing service
     * @param service Updated service
     * @return true if successful, false otherwise
     */
    public boolean updateService(Service service) {
        if (service == null || service.getId() == null || service.getId().trim().isEmpty() || 
            service.getName() == null || service.getName().trim().isEmpty()) {
            return false;
        }
        
        return serviceRepository.updateService(service);
    }
    
    /**
     * Delete a service by ID
     * @param id Service ID
     * @return true if successful, false otherwise
     */
    public boolean deleteService(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }
        
        return serviceRepository.deleteService(id);
    }
    
    /**
     * Get services by category
     * @param category Category name
     * @return List of services in the category
     */
    public List<Service> getServicesByCategory(String category) {
        if (category == null || category.trim().isEmpty() || category.equals("All Categories")) {
            return getAllServices();
        }
        
        List<Service> allServices = getAllServices();
        List<Service> filteredServices = new ArrayList<>();
        
        for (Service service : allServices) {
            if (service.getCategory().equals(category)) {
                filteredServices.add(service);
            }
        }
        
        return filteredServices;
    }
    
    /**
     * Get services by status
     * @param status Status (Active, Inactive, Premium)
     * @return List of services with the status
     */
    public List<Service> getServicesByStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return getAllServices();
        }
        
        List<Service> allServices = getAllServices();
        List<Service> filteredServices = new ArrayList<>();
        
        for (Service service : allServices) {
            if (service.getStatus().equals(status)) {
                filteredServices.add(service);
            }
        }
        
        return filteredServices;
    }
    
    /**
     * Search services by name
     * @param query Search query
     * @return List of matching services
     */
    public List<Service> searchServices(String query) {
        if (query == null || query.trim().isEmpty()) {
            return getAllServices();
        }
        
        List<Service> allServices = getAllServices();
        List<Service> matchingServices = new ArrayList<>();
        String lowerQuery = query.toLowerCase();
        
        for (Service service : allServices) {
            if (service.getName().toLowerCase().contains(lowerQuery) || 
                service.getDescription().toLowerCase().contains(lowerQuery) ||
                service.getCategory().toLowerCase().contains(lowerQuery)) {
                matchingServices.add(service);
            }
        }
        
        return matchingServices;
    }
    
    /**
     * Sort services by different criteria
     * @param services List of services to sort
     * @param sortBy Sort criteria (price-asc, price-desc, duration, popularity)
     * @return Sorted list of services
     */
    public List<Service> sortServices(List<Service> services, String sortBy) {
        if (services == null || services.size() <= 1 || sortBy == null) {
            return services;
        }
        
        List<Service> sortedList = new ArrayList<>(services);
        
        switch (sortBy) {
            case "price-asc":
                sortedList.sort((s1, s2) -> Double.compare(s1.getPrice(), s2.getPrice()));
                break;
            case "price-desc":
                sortedList.sort((s1, s2) -> Double.compare(s2.getPrice(), s1.getPrice()));
                break;
            case "duration":
                sortedList.sort((s1, s2) -> Integer.compare(s1.getDuration(), s2.getDuration()));
                break;
            case "name-asc":
                sortedList.sort((s1, s2) -> s1.getName().compareTo(s2.getName()));
                break;
            case "name-desc":
                sortedList.sort((s1, s2) -> s2.getName().compareTo(s1.getName()));
                break;
            default:
                // Default sort by name
                sortedList.sort((s1, s2) -> s1.getName().compareTo(s2.getName()));
                break;
        }
        
        return sortedList;
    }
}
