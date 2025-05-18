package com.beauty.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Appointment model class representing a salon appointment
 */
public class Appointment implements Serializable {
    private String id;
    private String userId;
    private String userName;
    private String service;
    private String stylist;
    private LocalDateTime dateTime;
    private String status;
    private String notes;
    
    // Default constructor
    public Appointment() {
    }
    
    // Parameterized constructor
    public Appointment(String id, String userId, String userName, String service, String stylist, 
                      LocalDateTime dateTime, String status, String notes) {
        this.id = id;
        this.userId = userId;
        this.userName = userName;
        this.service = service;
        this.stylist = stylist;
        this.dateTime = dateTime;
        this.status = status;
        this.notes = notes;
    }
    
    // Getters and Setters
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getService() {
        return service;
    }
    
    public void setService(String service) {
        this.service = service;
    }
    
    public String getStylist() {
        return stylist;
    }
    
    public void setStylist(String stylist) {
        this.stylist = stylist;
    }
    
    public LocalDateTime getDateTime() {
        return dateTime;
    }
    
    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    @Override
    public String toString() {
        return "Appointment{" +
                "id='" + id + '\'' +
                ", userId='" + userId + '\'' +
                ", userName='" + userName + '\'' +
                ", service='" + service + '\'' +
                ", stylist='" + stylist + '\'' +
                ", dateTime=" + dateTime +
                ", status='" + status + '\'' +
                ", notes='" + notes + '\'' +
                '}';
    }
    
    /**
     * Convert appointment to CSV format for file storage
     * @return CSV formatted string
     */
    public String toCsvString() {
        return String.join(",", 
                id, 
                userId, 
                userName, 
                service, 
                stylist, 
                dateTime.toString(), 
                status, 
                notes != null ? notes.replace(",", ";") : "");
    }
    
    /**
     * Create appointment from CSV string
     * @param csvLine CSV formatted string
     * @return Appointment object
     */
    public static Appointment fromCsvString(String csvLine) {
        String[] parts = csvLine.split(",");
        if (parts.length < 7) {
            throw new IllegalArgumentException("Invalid CSV format for Appointment");
        }
        
        Appointment appointment = new Appointment();
        appointment.setId(parts[0]);
        appointment.setUserId(parts[1]);
        appointment.setUserName(parts[2]);
        appointment.setService(parts[3]);
        appointment.setStylist(parts[4]);
        appointment.setDateTime(LocalDateTime.parse(parts[5]));
        appointment.setStatus(parts[6]);
        
        if (parts.length > 7) {
            appointment.setNotes(parts[7].replace(";", ","));
        }
        
        return appointment;
    }
}
