//
//  AuthServiceSpec.swift
//  Eber
//
//  Created by myung gi son on 21/09/2019.
//

import RxSwift
import KeychainAccess
import Quick
import Nimble
import Stubber
import Moya
import RxBlocking

@testable import Eber

final class AuthServiceSpec: QuickSpec {
  
  override func spec() {
    
    func createAuthService(
      networking: NetworkingStub = .init(),
      accessTokenStore: AccessTokenStoreStub = .init()
    ) -> AuthService {
      return AuthService(networking: networking, accessTokenStore: accessTokenStore)
    }
    
    var accessTokenStoreStub: AccessTokenStoreStub!
    var networkingStub: NetworkingStub!
    var authService: AuthService!
    
    beforeEach {
      accessTokenStoreStub = AccessTokenStoreStub()
      networkingStub = NetworkingStub()
      authService = createAuthService(
        networking: networkingStub,
        accessTokenStore: accessTokenStoreStub
      )
    }
    
    context("while initializing") {
      it("loads access token from AccessTokenStore") {
        Stubber.register(accessTokenStoreStub.loadAccessToken) { _ in nil }
        authService = createAuthService(accessTokenStore: accessTokenStoreStub)
        expect(Stubber.executions(accessTokenStoreStub.loadAccessToken).count) == 1
      }
    }
    
    context("when succeeds to authorize") {
      it("saves access token to AccessTokenStore") {
        Stubber.register(accessTokenStoreStub.saveAccessToken) { _ in }
        Stubber.register(networkingStub.request) { _ in
          let jsonData = (try? JSONEncoder().encode(AccessTokenFixture.accessToken)) ?? Data()
          return .just(Response(statusCode: 200, data: jsonData))
        }
        _ = authService.authorize(auth: AuthFixture.auth).toBlocking().materialize()
        expect(Stubber.executions(accessTokenStoreStub.saveAccessToken).count) == 1
      }
    }

    context("when sign out") {
      it("remove access token from AccessTokenStore") {
        Stubber.register(accessTokenStoreStub.deleteAccessToken) { _ in }
        authService.signOut()
        expect(Stubber.executions(accessTokenStoreStub.deleteAccessToken).count) == 1
      }
    }
  }
}
