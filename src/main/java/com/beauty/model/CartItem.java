package com.beauty.model;

import java.util.HashMap;
import java.util.Map;

/**
 * Represents an item in the service cart with quantity and options
 */
public class CartItem {
    private Service service;
    private int quantity;
    private Map<String, String> options;
    private String specialInstructions;
    
    /**
     * Constructor with service
     * @param service The service
     */
    public CartItem(Service service) {
        this.service = service;
        this.quantity = 1;
        this.options = new HashMap<>();
        this.specialInstructions = "";
    }
    
    /**
     * Constructor with service and quantity
     * @param service The service
     * @param quantity The quantity
     */
    public CartItem(Service service, int quantity) {
        this.service = service;
        this.quantity = quantity;
        this.options = new HashMap<>();
        this.specialInstructions = "";
    }
    
    /**
     * Constructor with all parameters
     * @param service The service
     * @param quantity The quantity
     * @param options Map of options
     * @param specialInstructions Special instructions
     */
    public CartItem(Service service, int quantity, Map<String, String> options, String specialInstructions) {
        this.service = service;
        this.quantity = quantity;
        this.options = options != null ? options : new HashMap<>();
        this.specialInstructions = specialInstructions != null ? specialInstructions : "";
    }
    
    /**
     * Get the service
     * @return The service
     */
    public Service getService() {
        return service;
    }
    
    /**
     * Set the service
     * @param service The service
     */
    public void setService(Service service) {
        this.service = service;
    }
    
    /**
     * Get the quantity
     * @return The quantity
     */
    public int getQuantity() {
        return quantity;
    }
    
    /**
     * Set the quantity
     * @param quantity The quantity
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity > 0 ? quantity : 1;
    }
    
    /**
     * Get the options
     * @return Map of options
     */
    public Map<String, String> getOptions() {
        return options;
    }
    
    /**
     * Set the options
     * @param options Map of options
     */
    public void setOptions(Map<String, String> options) {
        this.options = options != null ? options : new HashMap<>();
    }
    
    /**
     * Add an option
     * @param key Option key
     * @param value Option value
     */
    public void addOption(String key, String value) {
        if (key != null && !key.isEmpty()) {
            options.put(key, value);
        }
    }
    
    /**
     * Remove an option
     * @param key Option key
     */
    public void removeOption(String key) {
        if (key != null && !key.isEmpty()) {
            options.remove(key);
        }
    }
    
    /**
     * Get special instructions
     * @return Special instructions
     */
    public String getSpecialInstructions() {
        return specialInstructions;
    }
    
    /**
     * Set special instructions
     * @param specialInstructions Special instructions
     */
    public void setSpecialInstructions(String specialInstructions) {
        this.specialInstructions = specialInstructions != null ? specialInstructions : "";
    }
    
    /**
     * Get the total price (service price * quantity)
     * @return Total price
     */
    public double getTotalPrice() {
        return service.getPrice() * quantity;
    }
    
    /**
     * Get the total duration (service duration * quantity)
     * @return Total duration in minutes
     */
    public int getTotalDuration() {
        return service.getDuration() * quantity;
    }
    
    /**
     * Check if this cart item has the given service ID
     * @param serviceId Service ID to check
     * @return true if this cart item has the service ID, false otherwise
     */
    public boolean hasServiceId(String serviceId) {
        return service != null && service.getId().equals(serviceId);
    }
}
