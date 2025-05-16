package com.beauty.service;

import com.beauty.model.User;
import com.beauty.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;

/**
 * Service class for user-related operations
 */
public class
UserService {
    private UserRepository userRepository;

    public UserService() {
        this.userRepository = new UserRepository();
    }

    /**
     * Register a new user
     * @param firstName First name
     * @param lastName Last name
     * @param email Email
     * @param phoneNumber Phone number
     * @param password Password
     * @return true if registration successful, false otherwise
     */
    public boolean registerUser(String firstName, String lastName, String email, String phoneNumber, String password) {
        // Basic validation
        if (firstName == null || lastName == null || email == null || password == null ||
            firstName.trim().isEmpty() || lastName.trim().isEmpty() ||
            email.trim().isEmpty() || password.trim().isEmpty()) {
            return false;
        }

        // Create new user
        User user = new User(firstName, lastName, email, phoneNumber, password);

        // Save user
        return userRepository.saveUser(user);
    }

    /**
     * Authenticate a user
     * @param email Email
     * @param password Password
     * @return The authenticated user if successful, null otherwise
     */
    public User authenticateUser(String email, String password) {
        // Basic validation
        if (email == null || password == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }

        // Authenticate user
        return userRepository.authenticateUser(email, password);
    }

    /**
     * Check if a user with the given email exists
     * @param email Email to check
     * @return true if user exists, false otherwise
     */
    public boolean userExists(String email) {
        return userRepository.getUserByEmail(email) != null;
    }

    /**
     * Get a user by email
     * @param email Email of the user to retrieve
     * @return The user if found, null otherwise
     */
    public User getUserByEmail(String email) {
        return userRepository.getUserByEmail(email);
    }

    /**
     * Update an existing user's profile
     * @param email Current email (used as identifier)
     * @param firstName New first name
     * @param lastName New last name
     * @param phoneNumber New phone number
     * @param password New password (or current if unchanged)
     * @return true if update successful, false otherwise
     */
    public boolean updateUserProfile(String email, String firstName, String lastName,
                                    String phoneNumber, String password) {
        // Basic validation
        if (firstName == null || lastName == null || email == null || password == null ||
            firstName.trim().isEmpty() || lastName.trim().isEmpty() ||
            email.trim().isEmpty() || password.trim().isEmpty()) {
            return false;
        }

        // Get existing user
        User existingUser = userRepository.getUserByEmail(email);
        if (existingUser == null) {
            return false; // User not found
        }

        // Update user information
        existingUser.setFirstName(firstName);
        existingUser.setLastName(lastName);
        existingUser.setPhoneNumber(phoneNumber);
        existingUser.setPassword(password);

        // Save updated user
        return userRepository.updateUser(existingUser);
    }

    /**
     * Delete a user account
     * @param email Email of the user to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteUser(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        return userRepository.deleteUser(email);
    }

    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAllUsers() {
        return userRepository.getAllUsers();
    }

    /**
     * Sort users using quick sort algorithm
     * @param users List of users to sort
     * @param sortBy Sorting criteria (name-asc, name-desc, email-asc, email-desc)
     * @return Sorted list of users
     */
    public List<User> sortUsers(List<User> users, String sortBy) {
        if (users == null || users.size() <= 1) {
            return users;
        }

        // Create a copy of the list to avoid modifying the original
        List<User> sortedList = new ArrayList<>(users);

        // Perform quick sort
        quickSort(sortedList, 0, sortedList.size() - 1, sortBy);

        return sortedList;
    }

    /**
     * Quick sort implementation for users
     * @param users List of users to sort
     * @param low Starting index
     * @param high Ending index
     * @param sortBy Sorting criteria
     */
    private void quickSort(List<User> users, int low, int high, String sortBy) {
        if (low < high) {
            // Find the partition index
            int partitionIndex = partition(users, low, high, sortBy);

            // Recursively sort elements before and after partition
            quickSort(users, low, partitionIndex - 1, sortBy);
            quickSort(users, partitionIndex + 1, high, sortBy);
        }
    }

    /**
     * Partition function for quick sort
     * @param users List of users
     * @param low Starting index
     * @param high Ending index
     * @param sortBy Sorting criteria
     * @return Partition index
     */
    private int partition(List<User> users, int low, int high, String sortBy) {
        // Choose the pivot as the high element
        User pivot = users.get(high);
        int i = low - 1;

        for (int j = low; j < high; j++) {
            // Compare based on sorting criteria
            if (compareUsers(users.get(j), pivot, sortBy) <= 0) {
                i++;

                // Swap users[i] and users[j]
                User temp = users.get(i);
                users.set(i, users.get(j));
                users.set(j, temp);
            }
        }

        // Swap users[i+1] and users[high] (pivot)
        User temp = users.get(i + 1);
        users.set(i + 1, users.get(high));
        users.set(high, temp);

        return i + 1;
    }

    /**
     * Compare two users based on sorting criteria
     * @param u1 First user
     * @param u2 Second user
     * @param sortBy Sorting criteria
     * @return Comparison result (-1, 0, 1)
     */
    private int compareUsers(User u1, User u2, String sortBy) {
        if (sortBy == null) {
            // Default: sort by name ascending
            return (u1.getFirstName() + " " + u1.getLastName())
                    .compareTo(u2.getFirstName() + " " + u2.getLastName());
        }

        switch (sortBy) {
            case "name-asc":
                return (u1.getFirstName() + " " + u1.getLastName())
                        .compareTo(u2.getFirstName() + " " + u2.getLastName());
            case "name-desc":
                return (u2.getFirstName() + " " + u2.getLastName())
                        .compareTo(u1.getFirstName() + " " + u1.getLastName());
            case "email-asc":
                return u1.getEmail().compareTo(u2.getEmail());
            case "email-desc":
                return u2.getEmail().compareTo(u1.getEmail());
            default:
                return (u1.getFirstName() + " " + u1.getLastName())
                        .compareTo(u2.getFirstName() + " " + u2.getLastName());
        }
    }
}
