package com.beauty.model;

/**
 * Model class for Beauty Salon Services
 */
public class Service {
    private String id;
    private String name;
    private String category;
    private int duration; // in minutes
    private double price;
    private String status; // "Active", "Inactive", "Premium"
    private String description;
    private String icon; // Font Awesome icon class

    // Constructors
    public Service() {
    }

    public Service(String id, String name, String category, int duration, double price, String status, String description, String icon) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.duration = duration;
        this.price = price;
        this.status = status;
        this.description = description;
        this.icon = icon;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    @Override
    public String toString() {
        return id + "," + name + "," + category + "," + duration + "," + price + "," + status + "," + description + "," + icon;
    }
}
