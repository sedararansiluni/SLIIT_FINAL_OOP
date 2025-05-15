package com.beauty.repository;

import com.beauty.model.Appointment;

import java.io.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Repository class for handling file-based appointment storage operations
 */
public class AppointmentRepository {
    private static final String APPOINTMENTS_FILE = "C:\\Users\\nadeesha\\OneDrive\\Desktop\\Beauty_version 01 (2)\\Beauty_version 01\\Beauty\\src\\main\\webapp\\Database\\Appoinments.txt";

    /**
     * Save a new appointment to the file
     * @param appointment The appointment to save
     * @return true if successful, false otherwise
     */
    public boolean saveAppointment(Appointment appointment) {
        // Generate ID if not provided
        if (appointment.getId() == null || appointment.getId().isEmpty()) {
            appointment.setId(UUID.randomUUID().toString());
        }

        List<Appointment> appointments = getAllAppointments();
        appointments.add(appointment);

        return saveAllAppointments(appointments);
    }

    /**
     * Get all appointments from the file
     * @return List of all appointments
     */
    public List<Appointment> getAllAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        File file = new File(getAppointmentsFilePath());

        // If file doesn't exist, return empty list
        if (!file.exists()) {
            return appointments;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    try {
                        Appointment appointment = Appointment.fromCsvString(line);
                        appointments.add(appointment);
                    } catch (Exception e) {
                        System.out.println("Error parsing appointment: " + e.getMessage());
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading appointments file: " + e.getMessage());
        }

        return appointments;
    }

    /**
     * Get appointments for a specific user
     * @param userId The user ID
     * @return List of user's appointments
     */
    public List<Appointment> getAppointmentsByUserId(String userId) {
        List<Appointment> allAppointments = getAllAppointments();
        List<Appointment> userAppointments = new ArrayList<>();

        for (Appointment appointment : allAppointments) {
            if (appointment.getUserId().equals(userId)) {
                userAppointments.add(appointment);
            }
        }

        return userAppointments;
    }

    /**
     * Get appointments for a specific date
     * @param date The date to filter by
     * @return List of appointments on that date
     */
    public List<Appointment> getAppointmentsByDate(LocalDateTime date) {
        List<Appointment> allAppointments = getAllAppointments();
        List<Appointment> dateAppointments = new ArrayList<>();

        for (Appointment appointment : allAppointments) {
            if (appointment.getDateTime().toLocalDate().equals(date.toLocalDate())) {
                dateAppointments.add(appointment);
            }
        }

        return dateAppointments;
    }

    /**
     * Save all appointments to the file
     * @param appointments The list of appointments to save
     * @return true if successful, false otherwise
     */
    private boolean saveAllAppointments(List<Appointment> appointments) {
        File file = new File(getAppointmentsFilePath());

        // Create parent directories if they don't exist
        File parentDir = file.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            parentDir.mkdirs();
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Appointment appointment : appointments) {
                writer.write(appointment.toCsvString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.out.println("Error writing to appointments file: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get an appointment by ID
     * @param id The appointment ID
     * @return The appointment if found, null otherwise
     */
    public Appointment getAppointmentById(String id) {
        List<Appointment> allAppointments = getAllAppointments();

        for (Appointment appointment : allAppointments) {
            if (appointment.getId().equals(id)) {
                return appointment;
            }
        }

        return null;
    }

    /**
     * Update an existing appointment
     * @param updatedAppointment The updated appointment
     * @return true if successful, false otherwise
     */
    public boolean updateAppointment(Appointment updatedAppointment) {
        if (updatedAppointment == null || updatedAppointment.getId() == null) {
            return false;
        }

        List<Appointment> appointments = getAllAppointments();
        boolean found = false;

        for (int i = 0; i < appointments.size(); i++) {
            if (appointments.get(i).getId().equals(updatedAppointment.getId())) {
                appointments.set(i, updatedAppointment);
                found = true;
                break;
            }
        }

        if (!found) {
            return false;
        }

        return saveAllAppointments(appointments);
    }

    /**
     * Delete an appointment by ID
     * @param id The appointment ID
     * @return true if successful, false otherwise
     */
    public boolean deleteAppointment(String id) {
        if (id == null) {
            return false;
        }

        List<Appointment> appointments = getAllAppointments();
        boolean removed = false;

        for (int i = 0; i < appointments.size(); i++) {
            if (appointments.get(i).getId().equals(id)) {
                appointments.remove(i);
                removed = true;
                break;
            }
        }

        if (!removed) {
            return false;
        }

        return saveAllAppointments(appointments);
    }

    /**
     * Get the full path to the appointments file
     * @return The file path
     */
    private String getAppointmentsFilePath() {
        return  APPOINTMENTS_FILE;
    }
}
