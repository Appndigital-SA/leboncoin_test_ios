//
//  LBCModule.swift
//  leboncoin
//
//  Created by Didier Nizard on 16/06/2024.
//

extension InjectedValues {
    var apiServiceProvider: ApiService {
        get { Self[ApiServiceProviderKey.self] }
        set { Self[ApiServiceProviderKey.self] = newValue }
    }
    
    var itemRepositoryProvider: ItemRepository {
        get { Self[ItemRepositoryProviderKey.self] }
        set { Self[ItemRepositoryProviderKey.self] = newValue }
    }
    
    var getItemListUseCaseProvider: GetItemListUseCase {
        get { Self[GetItemListUseCaseProviderKey.self] }
        set { Self[GetItemListUseCaseProviderKey.self] = newValue }
    }
    
    var getCategoryListUseCaseProvider: GetCategorieListUseCase {
        get { Self[GetCategorieListUseCaseProviderKey.self] }
        set { Self[GetCategorieListUseCaseProviderKey.self] = newValue }
    }
}

private struct ApiServiceProviderKey: InjectionKey {
    static var currentValue: ApiService = ApiServiceImpl()
}

private struct ItemRepositoryProviderKey: InjectionKey {
    static var currentValue: ItemRepository = ItemRepositoryImpl()
}

private struct GetItemListUseCaseProviderKey: InjectionKey {
    static var currentValue: GetItemListUseCase = GetItemListUseCaseImpl()
}

private struct GetCategorieListUseCaseProviderKey: InjectionKey {
    static var currentValue: GetCategorieListUseCase = GetCategorieListUseCaseImpl()
}
