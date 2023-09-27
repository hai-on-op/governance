// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

address constant OP_SNX = 0x2E5ED97596a8368EB9E44B1f3F25B2E813845303;
address constant OP_SUSD = 0xeBaEAAD9236615542844adC5c149F86C36aD1136;
address constant OP_COLLATERAL_JOIN_FACTORY = 0xeB7E2307f2994e9E7C5153E1a3B3407a4BF9B421;
address constant OP_COLLATERAL_AUCTION_HOUSE_FACTORY = 0xf979110B7EEDce98603b504f73Fd71Db5BE8146a;
address constant OP_SAFE_ENGINE = 0x4ADe84BB4da143af07F9f89E00B65E3a08E2035A;
address constant OP_ORACLE_RELAYER = 0xB6AA4B291ff95565dd6ECd9F7C811372468520ff;
address constant OP_LIQUIDATION_ENGINE = 0xd7d402568046651FEDef30AD62d1b876b76F5EE6;
address constant OP_TAX_COLLECTOR = 0x99fBdeD15FCCC5D2284c3b07E438C76D3A9d045C;

bytes32 constant SNX = bytes32("SNX");
bytes32 constant SUSD = bytes32("SUSD");

interface IDelayedOracle {}

struct SAFEEngineCollateralParams {
    uint256 debtCeiling;
    uint256 debtFloor;
}

struct OracleRelayerCollateralParams {
    IDelayedOracle oracle;
    uint256 safetyCRatio;
    uint256 liquidationCRatio;
}

struct LiquidationEngineCollateralParams {
    address collateralAuctionHouse;
    uint256 liquidationPenalty;
    uint256 liquidationQuantity;
}

struct TaxCollectorCollateralParams {
    uint256 stabilityFee;
}

// is it better to use the interface or abstract contract
abstract contract CollateralJoin {

}

abstract contract CollateralJoinFactory {
    function deployCollateralJoin(
        bytes32 _cType,
        address _collateral
    ) external virtual returns (CollateralJoin);
}

abstract contract CollateralAuctionHouse {
    struct CollateralAuctionHouseParams {
        uint256 minimumBid;
        uint256 minDiscount;
        uint256 maxDiscount;
        uint256 perSecondDiscountUpdateRate;
    }
}

abstract contract CollateralAuctionHouseFactory {
    function deployCollateralAuctionHouse(
        bytes32 _cType,
        CollateralAuctionHouse.CollateralAuctionHouseParams calldata _cahParams
    ) external virtual returns (CollateralAuctionHouse);
}

abstract contract SAFEEngine {
    function initializeCollateralType(
        bytes32 _cType,
        SAFEEngineCollateralParams memory _collateralParams
    ) external virtual;
}

abstract contract OracleRelayer {
    function initializeCollateralType(
        bytes32 _cType,
        OracleRelayerCollateralParams memory _collateralParams
    ) external virtual;
}

abstract contract LiquidationEngine {
    function initializeCollateralType(
        bytes32 _cType,
        LiquidationEngineCollateralParams memory _collateralParams
    ) external virtual;
}

abstract contract TaxCollector {
    function initializeCollateralType(
        bytes32 _cType,
        TaxCollectorCollateralParams memory _collateralParams
    ) external;
}

contract Proposal1 {
    function setup() public {
        bytes32 _cType = SUSD;

        // Core Contracts
        SAFEEngine safeEngine = SAFEEngine(OP_SAFE_ENGINE);
        OracleRelayer oracleRelayer = OracleRelayer(OP_ORACLE_RELAYER);
        LiquidationEngine liquidationEngine = LiquidationEngine(
            OP_LIQUIDATION_ENGINE
        );
        TaxCollector taxCollector = TaxCollector(OP_TAX_COLLECTOR);

        // Deploy CollateralJoin
        CollateralJoinFactory collateralJoinFactory = CollateralJoinFactory(
            OP_COLLATERAL_JOIN_FACTORY
        );
        collateralJoinFactory.deployCollateralJoin({
            _cType: SUSD,
            _collateral: OP_SUSD
        });

        // Deploy CollateralAuctionHouse
        CollateralAuctionHouseFactory collateralAuctionHouseFactory = CollateralAuctionHouseFactory(
                OP_COLLATERAL_AUCTION_HOUSE_FACTORY
            );
        collateralAuctionHouseFactory.deployCollateralAuctionHouse({
            _cType: SUSD,
            _cahParams: CollateralAuctionHouse.CollateralAuctionHouseParams({
                minimumBid: 100,
                minDiscount: 100,
                maxDiscount: 100,
                perSecondDiscountUpdateRate: 100
            })
        });

        // Core Contract Collateral Params
        SAFEEngineCollateralParams
            memory _safeEngineCParams = SAFEEngineCollateralParams({
                debtCeiling: 10_000_000 * 1e18,
                debtFloor: 1 * 1e18
            });

        OracleRelayerCollateralParams
            memory _oracleRelayerCParams = OracleRelayerCollateralParams({
                oracle: delayedOracle[_cType],
                safetyCRatio: 1.5e27, // 150%
                liquidationCRatio: 1.5e27 // 150%
            });

        // Initialize Collateral Type on Core Contracts

        safeEngine.initializeCollateralType(_cType, _safeEngineCParams);

        // oracleRelayer.initializeCollateralType(_cType, _oracleRelayerCParams);
        // liquidationEngine.initializeCollateralType(
        //     _cType,
        //     _liquidationEngineCParams

        // );

        // taxCollector.initializeCollateralType(_cType, _taxCollectorCParams);
    }
}
