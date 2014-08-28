//
//  A0TokenSpec.m
//  Auth0Client
//
//  Created by Hernan Zalazar on 8/28/14.
//  Copyright 2014 Auth0. All rights reserved.
//

#import "Specta.h"
#import "A0Token.h"

#define kAccessToken @"ACCESS TOKEN"
#define kIdToken @"ID TOKEN"
#define kTokenType @"BEARER"

SpecBegin(A0Token)

describe(@"A0Token", ^{

    __block A0Token *token;

    NSDictionary *jsonDict = @{
                               @"access_token": kAccessToken,
                               @"id_token": kIdToken,
                               @"token_type": kTokenType,
                               };

    sharedExamplesFor(@"invalid token", ^(NSDictionary *data) {

        it(@"should raise exception", ^{
            expect(^{
                token = [[A0Token alloc] initWithDictionary:data];
            }).to.raise(NSInternalInconsistencyException);
        });

    });

    sharedExamplesFor(@"valid basic token", ^(NSDictionary *data) {

        beforeEach(^{
            token = data[@"token"];
        });

        specify(@"valid id token", ^{
            expect(token.idToken).to.equal(kIdToken);
        });

        specify(@"valid token type", ^{
            expect(token.tokenType).to.equal(kTokenType);
        });

    });

    sharedExamplesFor(@"valid complete token", ^(NSDictionary *data) {

        beforeEach(^{
            token = data[@"token"];
        });

        itShouldBehaveLike(@"valid basic token", data);

        specify(@"valid access token", ^{
            expect(token.accessToken).to.equal(kAccessToken);
        });

    });

    context(@"creating from JSON", ^{

        itShouldBehaveLike(@"valid complete token", @{ @"token": [[A0Token alloc] initWithDictionary:jsonDict] });

        itShouldBehaveLike(@"valid basic token", ^{
            NSMutableDictionary *dict = [jsonDict mutableCopy];
            [dict removeObjectForKey:@"access_token"];
            return @{ @"token": [[A0Token alloc] initWithDictionary:dict] };
        });

        itBehavesLike(@"invalid token", @{});
        itBehavesLike(@"invalid token", @{ @"access_token": kAccessToken });
        itBehavesLike(@"invalid token", @{ @"access_token": kAccessToken, @"token_type": kTokenType });
        itBehavesLike(@"invalid token", @{ @"access_token": kAccessToken, @"id_token": kIdToken });
    });
});

SpecEnd
