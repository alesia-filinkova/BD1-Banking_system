package net.javaguiedes.Banking_app.exception;

import java.time.LocalDateTime;

public record ErrorDetails(LocalDateTime timestamp,
                           String message,
                           String datails,
                           String errorCode) {
}
