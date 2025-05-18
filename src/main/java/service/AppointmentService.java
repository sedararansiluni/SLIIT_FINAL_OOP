package com.beauty.service;

import com.beauty.model.Appointment;
import com.beauty.model.User;
import com.beauty.repository.AppointmentRepository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Service class for appointment-related operations
 */
public class AppointmentService {
    private AppointmentRepository appointmentRepository;

    public AppointmentService() {
        this.appointmentRepository = new AppointmentRepository();
    }

    /**
     * Book a new appointment
     * @param user The user booking the appointment
     * @param service The service requested
     * @param stylist The stylist requested
     * @param dateTimeStr The date and time in format yyyy-MM-dd'T'HH:mm
     * @param notes Any additional notes
     * @return true if booking successful, false otherwise
     */
    public boolean bookAppointment(User user, String service, String stylist, String dateTimeStr, String notes) {
        // Basic validation
        if (user == null || service == null || stylist == null || dateTimeStr == null ||
            service.trim().isEmpty() || stylist.trim().isEmpty() || dateTimeStr.trim().isEmpty()) {
            return false;
        }

        try {
            // Parse date and time
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime dateTime = LocalDateTime.parse(dateTimeStr, formatter);

            // Create new appointment
            Appointment appointment = new Appointment();
            appointment.setUserId(user.getEmail()); // Using email as user ID
            appointment.setUserName(user.getFirstName() + " " + user.getLastName());
            appointment.setService(service);
            appointment.setStylist(stylist);
            appointment.setDateTime(dateTime);
            appointment.setStatus("Scheduled");
            appointment.setNotes(notes);

            // Save appointment
            return appointmentRepository.saveAppointment(appointment);
        } catch (Exception e) {
            System.out.println("Error booking appointment: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get all appointments for a user
     * @param user The user
     * @return List of user's appointments
     */
    public List<Appointment> getUserAppointments(User user) {
        if (user == null) {
            return List.of();
        }

        return appointmentRepository.getAppointmentsByUserId(user.getEmail());
    }

    /**
     * Get all appointments
     * @return List of all appointments
     */
    public List<Appointment> getAllAppointments() {
        return appointmentRepository.getAllAppointments();
    }

    /**
     * Get appointments for a specific date
     * @param date The date
     * @return List of appointments on that date
     */
    public List<Appointment> getAppointmentsByDate(LocalDateTime date) {
        return appointmentRepository.getAppointmentsByDate(date);
    }

    /**
     * Get an appointment by ID
     * @param id The appointment ID
     * @return The appointment if found, null otherwise
     */
    public Appointment getAppointmentById(String id) {
        if (id == null || id.trim().isEmpty()) {
            return null;
        }

        return appointmentRepository.getAppointmentById(id);
    }

    /**
     * Reschedule an appointment
     * @param id The appointment ID
     * @param newDateTime The new date and time
     * @return true if successful, false otherwise
     */
    public boolean rescheduleAppointment(String id, LocalDateTime newDateTime) {
        if (id == null || id.trim().isEmpty() || newDateTime == null) {
            return false;
        }

        // Get the appointment
        Appointment appointment = appointmentRepository.getAppointmentById(id);
        if (appointment == null) {
            return false;
        }

        // Update the date and time
        appointment.setDateTime(newDateTime);

        // Save the updated appointment
        return appointmentRepository.updateAppointment(appointment);
    }

    /**
     * Cancel an appointment
     * @param id The appointment ID
     * @return true if successful, false otherwise
     */
    public boolean cancelAppointment(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }

        // Get the appointment
        Appointment appointment = appointmentRepository.getAppointmentById(id);
        if (appointment == null) {
            return false;
        }

        // Update the status to cancelled
        appointment.setStatus("Cancelled");

        // Save the updated appointment
        return appointmentRepository.updateAppointment(appointment);
    }

    /**
     * Sort appointments using Quick Sort algorithm
     * @param appointments List of appointments to sort
     * @param sortBy Sorting criteria (date-asc, date-desc, name-asc, name-desc)
     * @return Sorted list of appointments
     */
    public List<Appointment> sortAppointments(List<Appointment> appointments, String sortBy) {
        if (appointments == null || appointments.size() <= 1) {
            return appointments;
        }

        // Create a copy of the list to avoid modifying the original
        List<Appointment> sortedList = new ArrayList<>(appointments);

        // Perform quick sort
        quickSort(sortedList, 0, sortedList.size() - 1, sortBy);

        return sortedList;
    }

    /**
     * Quick sort implementation for appointments
     * @param appointments List of appointments to sort
     * @param low Starting index
     * @param high Ending index
     * @param sortBy Sorting criteria
     */
    private void quickSort(List<Appointment> appointments, int low, int high, String sortBy) {
        if (low < high) {
            // Find the partition index
            int partitionIndex = partition(appointments, low, high, sortBy);

            // Recursively sort elements before and after partition
            quickSort(appointments, low, partitionIndex - 1, sortBy);
            quickSort(appointments, partitionIndex + 1, high, sortBy);
        }
    }

    /**
     * Partition function for quick sort
     * @param appointments List of appointments
     * @param low Starting index
     * @param high Ending index
     * @param sortBy Sorting criteria
     * @return Partition index
     */
    private int partition(List<Appointment> appointments, int low, int high, String sortBy) {
        // Choose the pivot as the high element
        Appointment pivot = appointments.get(high);
        int i = low - 1;

        for (int j = low; j < high; j++) {
            // Compare based on sorting criteria
            if (compareAppointments(appointments.get(j), pivot, sortBy) <= 0) {
                i++;

                // Swap appointments[i] and appointments[j]
                Appointment temp = appointments.get(i);
                appointments.set(i, appointments.get(j));
                appointments.set(j, temp);
            }
        }

        // Swap appointments[i+1] and appointments[high] (pivot)
        Appointment temp = appointments.get(i + 1);
        appointments.set(i + 1, appointments.get(high));
        appointments.set(high, temp);

        return i + 1;
    }

    /**
     * Compare two appointments based on sorting criteria
     * @param a1 First appointment
     * @param a2 Second appointment
     * @param sortBy Sorting criteria
     * @return Comparison result (-1, 0, 1)
     */
    private int compareAppointments(Appointment a1, Appointment a2, String sortBy) {
        if (sortBy == null) {
            // Default: sort by date ascending
            return a1.getDateTime().compareTo(a2.getDateTime());
        }

        switch (sortBy) {
            case "date-asc":
                return a1.getDateTime().compareTo(a2.getDateTime());
            case "date-desc":
                return a2.getDateTime().compareTo(a1.getDateTime());
            case "name-asc":
                return a1.getUserName().compareTo(a2.getUserName());
            case "name-desc":
                return a2.getUserName().compareTo(a1.getUserName());
            default:
                return a1.getDateTime().compareTo(a2.getDateTime());
        }
    }

    /**
     * Update appointment status
     * @param id The appointment ID
     * @param status The new status
     * @return true if successful, false otherwise
     */
    public boolean updateAppointmentStatus(String id, String status) {
        if (id == null || id.trim().isEmpty() || status == null || status.trim().isEmpty()) {
            return false;
        }

        // Get the appointment
        Appointment appointment = appointmentRepository.getAppointmentById(id);
        if (appointment == null) {
            return false;
        }

        // Update the status
        appointment.setStatus(status);

        // Save the updated appointment
        return appointmentRepository.updateAppointment(appointment);
    }
}
