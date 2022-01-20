<template>
	<view class="container">
		<uParse v-if="richText" :content="richText" noData=" " />
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	import uParse from '@/components/uni/uParse/src/wxParse'
	export default {
		components: {
			uParse
		},
		data() {
			return {
				richText: ''
			}
		},
		methods: {

		},
		onLoad: function(options) {
			let that = this;
			util.request('index/getTreaty', {
				type: options.id
			}).then(function(res) {
        if (res.code === 0) {
          that.richText = res.data
        }
			});
		}
	}
</script>

<style>
	.container {
		margin: 0 20rpx;
	}
</style>
