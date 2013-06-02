//
//  UtilClass.m
//  advintage
//
//  Created by James White on 1/06/13.
//  Copyright (c) 2013 James White. All rights reserved.
//

#import "UtilClass.h"

@implementation UtilClass

+(UIFont *)appFontWithSize:(int)size {
    return [UIFont fontWithName:@"NixieOne-Regular" size:size];
}

+(NSString*)stringForCategory:(SBSearchCategory)category
{
    if (category == SBSearchCategoryAll)
        return @"all categories";
    else if (category == SBSearchCategoryAlcohol)
        return @"alcohol";
    else if (category == SBSearchCategoryChildren)
        return @"children";
    else if (category == SBSearchCategoryClassified)
        return @"classified";
    else if (category == SBSearchCategoryCleaning)
        return @"cleaning";
    else if (category == SBSearchCategoryClothing)
        return @"clothing";
    else if (category == SBSearchCategoryElectronics)
        return @"electronics";
    else if (category == SBSearchCategoryFood)
        return @"food";
    else if (category == SBSearchCategoryHealth)
        return @"health";
    else if (category == SBSearchCategoryMen)
        return @"men";
    else if (category == SBSearchCategoryTobacco)
        return @"tobacco";
    else if (category == SBSearchCategoryTransport)
        return @"transport";
    else if (category == SBSearchCategoryWomen)
        return @"women";
    else if (category == SBSearchCategoryEntertainment)
        return @"entertainment";
    else if (category == SBSearchCategoryHousehold)
        return @"household";
    else if (category == SBSearchCategoryFavourites)
        return @"favourites";
    
    return nil;
}

@end
