//
//  UserRepositoryImpl.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 06-10-25.
//

import CoreData

protocol UserRepository {
    func register(_ user: RegisterUserModel) async throws
}


final class UserRepositoryImpl: UserRepository {
    private let context = PersistenceController.shared.container.viewContext

    func register(_ user: RegisterUserModel) async throws {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", user.email)

        let existing = try context.fetch(request)
        if !existing.isEmpty {
            throw RegistrationError.userAlreadyExists
        }

        let newUser = UserEntity(context: context)
        newUser.firstName = user.firstName
        newUser.lastName = user.lastName
        newUser.email = user.email

        try context.save()

        KeychainService.shared.save(value: user.email, for: "userEmail")
        let hashed = PasswordHasher.hash(user.password)
        KeychainService.shared.save(value: hashed, for: "userPassword")
    }
}
