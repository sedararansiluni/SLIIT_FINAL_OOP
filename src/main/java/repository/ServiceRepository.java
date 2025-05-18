package com.beauty.repository;

import com.beauty.model.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Repository class for managing services
 */
public class ServiceRepository {
    private static final String SERVICES_FILE = "C:\\Users\\Venura\\Desktop\\CustomerDemo\\Beauty_version 01\\Beauty\\src\\main\\webapp\\Database\\services.txt";

    /**
     * Get all services
     * @return List of all services
     */
    public List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        File file = new File(getServicesFilePath());
        
        // Create file if it doesn't exist
        if (!file.exists()) {
            try {
                file.createNewFile();
                // Add some default services
                addDefaultServices();
            } catch (IOException e) {
                e.printStackTrace();
                return services;
            }
        }
        
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Service service = parseService(line);
                    if (service != null) {
                        services.add(service);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return services;
    }
    
    /**
     * Get a service by ID
     * @param id Service ID
     * @return Service if found, null otherwise
     */
    public Service getServiceById(String id) {
        List<Service> services = getAllServices();
        
        for (Service service : services) {
            if (service.getId().equals(id)) {
                return service;
            }
        }
        
        return null;
    }
    
    /**
     * Add a new service
     * @param service Service to add
     * @return true if successful, false otherwise
     */
    public boolean addService(Service service) {
        // Generate ID if not provided
        if (service.getId() == null || service.getId().trim().isEmpty()) {
            service.setId("SV-" + UUID.randomUUID().toString().substring(0, 8));
        }
        
        List<Service> services = getAllServices();
        services.add(service);
        
        return saveAllServices(services);
    }
    
    /**
     * Update an existing service
     * @param service Updated service
     * @return true if successful, false otherwise
     */
    public boolean updateService(Service service) {
        List<Service> services = getAllServices();
        boolean found = false;
        
        for (int i = 0; i < services.size(); i++) {
            if (services.get(i).getId().equals(service.getId())) {
                services.set(i, service);
                found = true;
                break;
            }
        }
        
        if (!found) {
            return false;
        }
        
        return saveAllServices(services);
    }
    
    /**
     * Delete a service by ID
     * @param id Service ID
     * @return true if successful, false otherwise
     */
    public boolean deleteService(String id) {
        List<Service> services = getAllServices();
        boolean removed = false;
        
        for (int i = 0; i < services.size(); i++) {
            if (services.get(i).getId().equals(id)) {
                services.remove(i);
                removed = true;
                break;
            }
        }
        
        if (!removed) {
            return false;
        }
        
        return saveAllServices(services);
    }
    
    /**
     * Save all services to file
     * @param services List of services to save
     * @return true if successful, false otherwise
     */
    private boolean saveAllServices(List<Service> services) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getServicesFilePath()))) {
            for (Service service : services) {
                writer.write(service.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Parse a service from a line of text
     * @param line Line of text
     * @return Service object
     */
    private Service parseService(String line) {
        try {
            String[] parts = line.split(",");
            if (parts.length >= 8) {
                String id = parts[0];
                String name = parts[1];
                String category = parts[2];
                int duration = Integer.parseInt(parts[3]);
                double price = Double.parseDouble(parts[4]);
                String status = parts[5];
                String description = parts[6];
                String icon = parts[7];
                
                return new Service(id, name, category, duration, price, status, description, icon);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Add default services if the file is empty
     */
    private void addDefaultServices() {
        List<Service> defaultServices = new ArrayList<>();
        
        defaultServices.add(new Service("SV-001", "Women's Haircut", "Hair Services", 45, 65.00, "Active", "Professional haircut for women", "fas fa-cut"));
        defaultServices.add(new Service("SV-002", "Deluxe Facial", "Skin Care", 60, 95.00, "Premium", "Luxurious facial treatment", "fas fa-spa"));
        defaultServices.add(new Service("SV-003", "Gel Manicure", "Nail Services", 45, 45.00, "Active", "Long-lasting gel nail polish", "fas fa-paint-brush"));
        defaultServices.add(new Service("SV-004", "Men's Haircut", "Hair Services", 30, 40.00, "Active", "Professional haircut for men", "fas fa-cut"));
        defaultServices.add(new Service("SV-005", "Bridal Makeup", "Makeup", 90, 120.00, "Premium", "Complete makeup for brides", "fas fa-spa"));
        
        saveAllServices(defaultServices);
    }
    
    /**
     * Get the full path to the services file
     * @return The file path
     */
    private String getServicesFilePath() {
        return SERVICES_FILE;
    }
}
