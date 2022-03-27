//
//  LoginUserModel.swift
//  sahem
//
//  Created by Weenggs Technology on 03/02/21.
//

import Foundation

// MARK: - LoginProviderModel
struct LoginProviderModel: Codable
{
    let error: Int?
    let token: String?
    let provider: Provider
    let providerOutstandingAmount: String?
    
    enum CodingKeys: String, CodingKey {
        case error, provider, token
        case providerOutstandingAmount = "provider_outstanding_amount"
    }
    
}

// MARK: - Provider
struct Provider: Codable {
    let id: Int?
    let firstName, lastName, email, apiToken: String?
    let token, profilePicture, address, latitude: String?
    let longitude, phone, companyID, paymentEmail: String?
    let accountHolderName, accountNumber, bankName, bankLocation: String?
    let bankIban, bicSwiftCode, serviceDescription, isActive: String?
    let isFeatured, createdAt, updatedAt, deletedAt: String?
    let referByUser, referByProvider, referralCode, rejectReason: String?
    let providerStatus, onlineStatus, serviceID, categoryID: String?
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case categoryID = "category_id"
        case email
        case apiToken = "api_token"
        case token
        case profilePicture = "profile_picture"
        case address, latitude, longitude, phone
        case companyID = "company_id"
        case paymentEmail = "payment_email"
        case accountHolderName = "account_holder_name"
        case accountNumber = "account_number"
        case bankName = "bank_name"
        case bankLocation = "bank_location"
        case bankIban = "bank_iban"
        case bicSwiftCode = "bic_swift_code"
        case serviceDescription = "service_description"
        case isActive = "is_active"
        case isFeatured = "is_featured"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case referByUser = "refer_by_user"
        case referByProvider = "refer_by_provider"
        case referralCode = "referral_code"
        case rejectReason = "reject_reason"
        case providerStatus = "provider_status"
        case onlineStatus = "online_status"
        case serviceID = "service_id"
        case profileImage = "profile_image"
    }
}
