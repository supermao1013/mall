<template>
	<view class="add-shops">
		<view class="form-item">
			<label>店铺名称</label>
			<input class="input" placeholder="店铺名称" readOnly v-model="shopsForm.name" />
		</view>
		<view class="form-item">
			<label>手机号码</label>
			<input class="input" v-model="shopsForm.telephone" readOnly placeholder="手机号码" />
		</view>
		<view class="form-item">
			<label>验证码</label>
			<input class="input" v-model="shopsForm.checkCode" readOnly placeholder="验证码" />
		</view>
		<view class="btns">
			<button class="save" @tap="bindBtn">绑定</button>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	const app = getApp();
	export default {
		data() {
			return {
				shopsForm: {
					id: '',
					name: '',
					shopsName: '',
					telephone: '',
					checkCode: ''
				},
				userInfo: []
			}
		},
		methods: {
			bindBtn() {
				let that = this;
				util.request('shops/shopsBind', {
					shopsId: that.shopsForm.id,
					checkCode: that.shopsForm.checkCode,
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						util.toast('绑定成功');
					}
				});
			},
			initShopsData() {
				let that = this;
				util.request('shops/detailBySn', {
					shopsSn: that.shopsForm.shopsSn
				}).then(function(res) {
					if (res.code === 0) {
						that.shopsForm = res.data
					}
				});
			}
		},
		onLoad: function(option) {
			let that = this;
			// let scene = option.scene;
			// if (JSON.stringify(option) !== '{}' && option.scene !== undefined) {
			// let scene = decodeURIComponent(option.scene);
			// let sceneData = {};
			// scene.split('&').forEach(item => {
			// 	sceneData[item.split('=')[0]] = (item.split('=')[1]);
			// })
			uni.setStorageSync("navUrl", "/pages/shops/shopsBind?shopsSn=" + option.shopsSn);
			console.log('scene', option);

			if (option.shopsSn && option.shopsSn != "0") {
				// if (sceneData.shopsSn && sceneData.shopsSn != "0") {
				this.shopsForm.shopsSn = option.shopsSn;
				that.initShopsData();
			}
			// }
		}
	}
</script>

<style>
	page {
		height: 100%;
		background: #f4f4f4;
	}

	.add-shops {
		background: #fff;
		width: 100%;
		height: auto;
		overflow: hidden;
	}

	.add-shops .form-item {
		height: 116rpx;
		padding-left: 31.25rpx;
		border-bottom: 1px solid #d9d9d9;
		display: flex;
		align-items: center;
		padding-right: 31.25rpx;
	}

	add-shops label {
		width: 160rpx;
		font-weight: bold;
	}

	.add-shops .input {
		flex: 1;
		height: 44rpx;
		line-height: 44rpx;
		margin-left: 20rpx;
		overflow: hidden;
	}

	.add-shops .btns {
		position: fixed;
		bottom: 0;
		left: 0;
		overflow: hidden;
		display: flex;
		height: 100rpx;
		width: 100%;
	}

	.add-shops .save {
		flex: 1;
		height: 100rpx;
		text-align: center;
		line-height: 100rpx;
		font-size: 28rpx;
		color: #fff;
		border: none;
		border-radius: 0;
	}

	.add-shops .save {
		background: #e41f19;
	}
</style>
