// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {CollateralJoinFactory} from "@contracts/factories/CollateralJoinFactory.sol";
import {CollateralJoinFactory} from "@contracts/factories/CollateralJoinFactory.sol";
import {CollateralAuctionHouse} from "@contracts/CollateralAuctionHouse.sol";
import {CollateralAuctionHouseFactory} from "@contracts/factories/CollateralAuctionHouseFactory.sol";
import {ICollateralAuctionHouse} from "@interfaces/ICollateralAuctionHouse.sol";

import {SAFEEngine, ISAFEEngine} from "@contracts/SAFEEngine.sol";
import {OracleRelayer, IOracleRelayer} from "@contracts/OracleRelayer.sol";
import {LiquidationEngine, ILiquidationEngine} from "@contracts/LiquidationEngine.sol";
import {TaxCollector, ITaxCollector} from "@contracts/TaxCollector.sol";
import {HardcodedOracle} from "@contracts/for-test/HardcodedOracle.sol";

import {IBaseOracle} from "@interfaces/oracles/IBaseOracle.sol";
import {DelayedOracle, IDelayedOracle} from "@contracts/oracles/DelayedOracle.sol";
import {ChainlinkRelayerFactory, IChainlinkRelayerFactory} from "@contracts/factories/ChainlinkRelayerFactory.sol";
import {DelayedOracleFactory, IDelayedOracleFactory} from "@contracts/factories/DelayedOracleFactory.sol";

import {WAD, RAD, RAY} from "@libraries/Math.sol";

address constant OP_SUSD = 0xeBaEAAD9236615542844adC5c149F86C36aD1136;
address constant OP_COLLATERAL_JOIN_FACTORY = 0xeB7E2307f2994e9E7C5153E1a3B3407a4BF9B421;
address constant OP_COLLATERAL_AUCTION_HOUSE_FACTORY = 0xf979110B7EEDce98603b504f73Fd71Db5BE8146a;
address constant OP_SAFE_ENGINE = 0x4ADe84BB4da143af07F9f89E00B65E3a08E2035A;
address constant OP_ORACLE_RELAYER = 0xB6AA4B291ff95565dd6ECd9F7C811372468520ff;
address constant OP_LIQUIDATION_ENGINE = 0xd7d402568046651FEDef30AD62d1b876b76F5EE6;
address constant OP_TAX_COLLECTOR = 0x99fBdeD15FCCC5D2284c3b07E438C76D3A9d045C;
address constant OP_CHAINLINK_RELAYER_FACTORY = 0x47F13CBB7E2dc7D52c67846aF2e62Cde32B5fE18;
address constant OP_DELAYED_ORACLE_FACTORY = 0x8d1Cd45Bd8ba43fBcC03F36Bc7D7304Cb1d4D0Fb;

address constant OP_GOERLI_CHAINLINK_SNX_USD_FEED = 0x89A7630f46B8c35A7fBBC4f6e4783f1E2DC715c6;
uint256 constant MINUS_0_5_PERCENT_PER_HOUR = 999_998_607_628_240_588_157_433_861;
bytes32 constant SUSD = bytes32("sUSD");

contract Proposal {
    function execute() public {
        SAFEEngine safeEngine = SAFEEngine(OP_SAFE_ENGINE);
        OracleRelayer oracleRelayer = OracleRelayer(OP_ORACLE_RELAYER);
        LiquidationEngine liquidationEngine = LiquidationEngine(OP_LIQUIDATION_ENGINE);
        TaxCollector taxCollector = TaxCollector(OP_TAX_COLLECTOR);

        CollateralJoinFactory collateralJoinFactory = CollateralJoinFactory(OP_COLLATERAL_JOIN_FACTORY);

        CollateralAuctionHouseFactory collateralAuctionHouseFactory =
            CollateralAuctionHouseFactory(OP_COLLATERAL_AUCTION_HOUSE_FACTORY);

        DelayedOracleFactory delayedOracleFactory = DelayedOracleFactory(OP_DELAYED_ORACLE_FACTORY);

        // Collateral Contract Params
        ICollateralAuctionHouse.CollateralAuctionHouseParams memory collateralAuctionHouseParams =
        ICollateralAuctionHouse.CollateralAuctionHouseParams({
            minimumBid: WAD, // 1 COINs
            minDiscount: WAD, // no discount
            maxDiscount: 0.9e18, // -10%
            perSecondDiscountUpdateRate: MINUS_0_5_PERCENT_PER_HOUR // RAY
        });

        // Deploy CollateralJoin
        collateralJoinFactory.deployCollateralJoin({_cType: SUSD, _collateral: OP_SUSD});

        ICollateralAuctionHouse collateralAuctionHouse =
            collateralAuctionHouseFactory.deployCollateralAuctionHouse(SUSD, collateralAuctionHouseParams);

        IBaseOracle susdOracle = new HardcodedOracle("sUSD", 1e18);

        IDelayedOracle susdDelayedOracle = delayedOracleFactory.deployDelayedOracle(susdOracle, 1 hours);

        ISAFEEngine.SAFEEngineCollateralParams memory safeEngineCParams = ISAFEEngine.SAFEEngineCollateralParams({
            debtCeiling: 10_000_000 * RAD, // 10M COINs
            debtFloor: 1 * RAD // 1 COINs
        });

        IOracleRelayer.OracleRelayerCollateralParams memory oracleRelayerCParams = IOracleRelayer
            .OracleRelayerCollateralParams({
            oracle: susdDelayedOracle,
            safetyCRatio: 1.5e27, // 150%
            liquidationCRatio: 1.5e27 // 150%
        });

        ITaxCollector.TaxCollectorCollateralParams memory taxCollectorCParams = ITaxCollector
            .TaxCollectorCollateralParams({
            stabilityFee: RAY + 1.54713e18 // + 5%/yr
        });

        ILiquidationEngine.LiquidationEngineCollateralParams memory liquidationEngineCParams = ILiquidationEngine
            .LiquidationEngineCollateralParams({
            collateralAuctionHouse: address(collateralAuctionHouse),
            liquidationPenalty: 1.1e18, // 10%
            liquidationQuantity: 1000 * RAD // 1000 COINs
        });

        // Initialize Collateral Type on Core Contracts
        safeEngine.initializeCollateralType(SUSD, safeEngineCParams);
        oracleRelayer.initializeCollateralType(SUSD, oracleRelayerCParams);
        liquidationEngine.initializeCollateralType(SUSD, liquidationEngineCParams);

        taxCollector.initializeCollateralType(SUSD, taxCollectorCParams);

        // setup initial price
        oracleRelayer.updateCollateralPrice(SUSD);
    }
}
