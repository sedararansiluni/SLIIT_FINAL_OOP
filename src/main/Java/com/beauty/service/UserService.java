package com.beauty.service;

import com.beauty.model.User;
import com.beauty.repository.UserRepository;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.regex.Pattern;

/**
 * Service class for user-related operations
 */
public class UserService {
    private static final Logger LOGGER = Logger.getLogger(UserService.class.getName());
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\+?[1-9]\\d{1,14}$");
    private UserRepository userRepository;

    public UserService() {
        this.userRepository = new UserRepository();
    }

    /**
     * Register a new user with validation and password hashing
     * @param firstName First name
     * @param lastName Last name
     * @param email Email
     * @param phoneNumber Phone number
     * @param password Password
     * @return true if registration successful, false otherwise
     * @throws IllegalArgumentException if input validation fails
     */
    public boolean registerUser(String firstName, String lastName, String email, String phoneNumber, String password) {
        try {
            // Input validation
            if (!isValidInput(firstName, lastName, email, phoneNumber, password)) {
                LOGGER.warning("Invalid input for registration: " + email);
                throw new IllegalArgumentException("Invalid input parameters");
            }

            // Sanitize inputs
            firstName = firstName.trim();
            lastName = lastName.trim();
            email = email.trim().toLowerCase();
            phoneNumber = phoneNumber.trim();

            // Validate email format
            if (!EMAIL_PATTERN.matcher(email).matches()) {
                LOGGER.warning("Invalid email format: " + email);
                throw new IllegalArgumentException("Invalid email format");
            }

            // Validate phone number format
            if (!PHONE_PATTERN.matcher(phoneNumber).matches()) {
                LOGGER.warning("Invalid phone number format: " + phoneNumber);
                throw new IllegalArgumentException("Invalid phone number format");
            }

            // Check if user already exists
            if (userExists(email)) {
                LOGGER.warning("User already exists: " + email);
                return false;
            }

            // Hash password
            String hashedPassword = hashPassword(password);
            
            // Create new user
            User user = new User(firstName, lastName, email, phoneNumber, hashedPassword);

            // Save user
            boolean success = userRepository.saveUser(user);
            if (success) {
                LOGGER.info("User registered successfully: " + email);
            }
            return success;
        } catch (Exception e) {
            LOGGER.severe("Error during registration for " + email + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * Authenticate a user with hashed password verification
     * @param email Email
     * @param password Password
     * @return The authenticated user if successful, null otherwise
     */
    public User authenticateUser(String email, String password) {
        try {
            if (email == null || password == null || 
                email.trim().isEmpty() || password.isEmpty()) {
                LOGGER.warning("Invalid authentication attempt: empty credentials");
                return null;
            }

            email = email.trim().toLowerCase();
            
            // Hash provided password for comparison
            String hashedPassword = hashPassword(password);
            
            User user = userRepository.authenticateUser(email, hashedPassword);
            if (user != null) {
                LOGGER.info("Successful authentication for: " + email);
            } else {
                LOGGER.warning("Failed authentication attempt for: " + email);
            }
            return user;
        } catch (Exception e) {
            LOGGER.severe("Error during authentication for " + email + ": " + e.getMessage());
            return null;
        }
    }

    /**
     * Check if a user with the given email exists
     * @param email Email to check
     * @return true if user exists, false otherwise
     */
    public boolean userExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        email = email.trim().toLowerCase();
        boolean exists = userRepository.getUserByEmail(email) != null;
        LOGGER.info("User existence check for " + email + ": " + exists);
        return exists;
    }

    /**
     * Get a user by email
     * @param email Email of the user to retrieve
     * @return The user if found, null otherwise
     */
    public User getUserByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        email = email.trim().toLowerCase();
        User user = userRepository.getUserByEmail(email);
        LOGGER.info("User retrieval for " + email + ": " + (user != null ? "found" : "not found"));
        return user;
    }

    /**
     * Update an existing user's profile
     * @param email Current email (used as identifier)
     * @param firstName New first name
     * @param lastName New last name
     * @param phoneNumber New phone number
     * @param password New password (or current if unchanged)
     * @return true if update successful, false otherwise
     * @throws IllegalArgumentException if input validation fails
     */
    public boolean updateUserProfile(String email, String firstName, String lastName,
                                    String phoneNumber, String password) {
        try {
            // Input validation
            if (!isValidInput(firstName, lastName, email, phoneNumber, password)) {
                LOGGER.warning("Invalid input for profile update: " + email);
                throw new IllegalArgumentException("Invalid input parameters");
            }

            // Sanitize inputs
            email = email.trim().toLowerCase();
            firstName = firstName.trim();
            lastName = lastName.trim();
            phoneNumber = phoneNumber.trim();

            // Validate email and phone number formats
            if (!EMAIL_PATTERN.matcher(email).matches()) {
                LOGGER.warning("Invalid email format for update: " + email);
                throw new IllegalArgumentException("Invalid email format");
            }
            if (!PHONE_PATTERN.matcher(phoneNumber).matches()) {
                LOGGER.warning("Invalid phone number format for update: " + phoneNumber);
                throw new IllegalArgumentException("Invalid phone number format");
            }

            // Get existing user
            User existingUser = userRepository.getUserByEmail(email);
            if (existingUser == null) {
                LOGGER.warning("User not found for update: " + email);
                return false;
            }

            // Hash new password
            String hashedPassword = hashPassword(password);

            // Update user information
            existingUser.setFirstName(firstName);
            existingUser.setLastName(lastName);
            existingUser.setPhoneNumber(phoneNumber);
            existingUser.setPassword(hashedPassword);

            // Save updated user
            boolean success = userRepository.updateUser(existingUser);
            if (success) {
                LOGGER.info("User profile updated successfully: " + email);
            }
            return success;
        } catch (Exception e) {
            LOGGER.severe("Error updating profile for " + email + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * Delete a user account
     * @param email Email of the user to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteUser(String email) {
        try {
            if (email == null || email.trim().isEmpty()) {
                LOGGER.warning("Invalid email for deletion");
                return false;
            }

            email = email.trim().toLowerCase();
            boolean success = userRepository.deleteUser(email);
            if (success) {
                LOGGER.info("User deleted successfully: " + email);
            }
            return success;
        } catch (Exception e) {
            LOGGER.severe("Error deleting user " + email + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAllUsers() {
        List<User> users = userRepository.getAllUsers();
        LOGGER.info("Retrieved " + users.size() + " users");
        return users;
    }

    /**
     * Sort users using optimized quick sort algorithm
     * @param users List of users to sort
     * @param sortBy Sorting criteria (name-asc, name-desc, email-asc, email-desc)
     * @return Sorted list of users
     */
    public List<User> sortUsers(List<User> users, String sortBy) {
        if (users == null || users.size() <= 1) {
            LOGGER.info("No sorting needed for list size: " + (users == null ? 0 : users.size()));
            return users == null ? new ArrayList<>() : users;
        }

        // Create a copy of the list
        List<User> sortedList = new ArrayList<>(users);
        
        // Use insertion sort for small lists
        if (sortedList.size() < 10) {
            insertionSort(sortedList, sortBy);
        } else {
            quickSort(sortedList, 0, sortedList.size() - 1, sortBy);
        }

        LOGGER.info("Sorted " + sortedList.size() + " users by " + sortBy);
        return sortedList;
    }

    /**
     * Insertion sort for small lists
     * @param users List of users to sort
     * @param sortBy Sorting criteria
     */
    private void insertionSort(List<User> users, String sortBy) {
        for (int i = 1; i < users.size(); i++) {
            User key = users.get(i);
            int j = i - 1;
            while (j >= 0 && compareUsers(users.get(j), key, sortBy) > 0) {
                users.set(j + 1, users.get(j));
                j--;
            }
            users.set(j + 1, key);
        }
    }

    /**
     * Optimized quick sort with median-of-three pivot
     * @param users List of users to sort
     * @param low Starting index
     * @param high Ending index
     * @param sortBy Sorting criteria
     */
    private void quickSort(List<User> users, int low, int high, String sortBy) {
        if (low < high) {
            // Use insertion sort for small subarrays
            if (high - low < 10) {
                insertionSortSubarray(users, low, high, sortBy);
                return;
            }

            int partitionIndex = partition(users, low, high, sortBy);
            quickSort(users, low, partitionIndex - 1, sortBy);
            quickSort(users, partitionIndex + 1, high, sortBy);
        }
    }

    /**
     * Insertion sort for small subarrays
     * @param users List of users
     * @param low Starting index
     * @param high Ending index
     * @param sortBy Sorting criteria
     */
    private void insertionSortSubarray(List<User> users, int low, int high, String sortBy) {
        for (int i = low + 1; i <= high; i++) {
            User key = users.get(i);
            int j = i - 1;
            while (j >= low && compareUsers(users.get(j), key, sortBy) > 0) {
                users.set(j + 1, users.get(j));
                j--;
            }
            users.set(j + 1, key);
        }
    }

    /**
     * Partition with median-of-three pivot selection
     * @param users List of users
     * @param low Starting index
     * @param high Ending index
     * @param sortBy Sorting criteria
     * @return Partition index
     */
    private int partition(List<User> users, int low, int high, String sortBy) {
        // Choose median of first, middle, and last elements as pivot
        int mid = low + (high - low) / 2;
        if (compareUsers(users.get(mid), users.get(low), sortBy) < 0)
            swap(users, low, mid);
        if (compareUsers(users.get(high), users.get(low), sortBy) < 0)
            swap(users, low, high);
        if (compareUsers(users.get(mid), users.get(high), sortBy) < 0)
            swap(users, mid, high);

        User pivot = users.get(high);
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (compareUsers(users.get(j), pivot, sortBy) <= 0) {
                i++;
                swap(users, i, j);
            }
        }

        swap(users, i + 1, high);
        return i + 1;
    }

    /**
     * Swap two elements in the list
     * @param users List of users
     * @param i First index
     * @param j Second index
     */
    private void swap(List<User> users, int i, int j) {
        User temp = users.get(i);
        users.set(i, users.get(j));
        users.set(j, temp);
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
            return compareByNameAsc(u1, u2);
        }

        switch (sortBy) {
            case "name-asc":
                return compareByNameAsc(u1, u2);
            case "name-desc":
                return compareByNameAsc(u2, u1);
            case "email-asc":
                return u1.getEmail().compareToIgnoreCase(u2.getEmail());
            case "email-desc":
                return u2.getEmail().compareToIgnoreCase(u1.getEmail());
            default:
                return compareByNameAsc(u1, u2);
        }
    }

    /**
     * Compare users by name ascending
     * @param u1 First user
     * @param u2 Second user
     * @return Comparison result
     */
    private int compareByNameAsc(User u1, User u2) {
        String name1 = u1.getFirstName() + " " + u1.getLastName();
        String name2 = u2.getFirstName() + " " + u2.getLastName();
        return name1.compareToIgnoreCase(name2);
    }

    /**
     * Validate input parameters
     * @param firstName First name
     * @param lastName Last name
     * @param email Email
     * @param phoneNumber Phone number
     * @param password Password
     * @return true if valid, false otherwise
     */
    private boolean isValidInput(String firstName, String lastName, String email, 
                               String phoneNumber, String password) {
        return firstName != null && !firstName.trim().isEmpty() &&
               lastName != null && !lastName.trim().isEmpty() &&
               email != null && !email.trim().isEmpty() &&
               phoneNumber != null && !phoneNumber.trim().isEmpty() &&
               password != null && !password.isEmpty();
    }

    /**
     * Hash password using SHA-256
     * @param password Password to hash
     * @return Hashed password
     * @throws NoSuchAlgorithmException if SHA-256 is not available
     */
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(password.getBytes());
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }
}