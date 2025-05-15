package com.beauty.util;

import com.beauty.model.Service;
import java.util.LinkedList;
import java.util.Queue;
import java.util.ArrayList;
import java.util.List;

/**
 * A utility class that implements a queue for services
 */
public class ServiceQueue {
    private static ServiceQueue instance;
    private Queue<Service> serviceQueue;
    
    // Private constructor for singleton pattern
    private ServiceQueue() {
        serviceQueue = new LinkedList<>();
    }
    
    /**
     * Get the singleton instance of ServiceQueue
     * @return ServiceQueue instance
     */
    public static synchronized ServiceQueue getInstance() {
        if (instance == null) {
            instance = new ServiceQueue();
        }
        return instance;
    }
    
    /**
     * Add a service to the queue
     * @param service Service to add
     */
    public void enqueue(Service service) {
        serviceQueue.add(service);
    }
    
    /**
     * Remove and return the next service from the queue
     * @return The next service or null if queue is empty
     */
    public Service dequeue() {
        return serviceQueue.poll();
    }
    
    /**
     * View the next service without removing it
     * @return The next service or null if queue is empty
     */
    public Service peek() {
        return serviceQueue.peek();
    }
    
    /**
     * Check if the queue is empty
     * @return true if queue is empty, false otherwise
     */
    public boolean isEmpty() {
        return serviceQueue.isEmpty();
    }
    
    /**
     * Get the size of the queue
     * @return Number of services in the queue
     */
    public int size() {
        return serviceQueue.size();
    }
    
    /**
     * Clear all services from the queue
     */
    public void clear() {
        serviceQueue.clear();
    }
    
    /**
     * Get all services in the queue as a list (without removing them)
     * @return List of all services in the queue
     */
    public List<Service> getAllServices() {
        return new ArrayList<>(serviceQueue);
    }
    
    /**
     * Check if a service with the given ID exists in the queue
     * @param serviceId Service ID to check
     * @return true if service exists in queue, false otherwise
     */
    public boolean containsService(String serviceId) {
        for (Service service : serviceQueue) {
            if (service.getId().equals(serviceId)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Remove a specific service from the queue by ID
     * @param serviceId Service ID to remove
     * @return true if service was removed, false if not found
     */
    public boolean removeService(String serviceId) {
        return serviceQueue.removeIf(service -> service.getId().equals(serviceId));
    }
}
